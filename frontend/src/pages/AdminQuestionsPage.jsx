import { useEffect, useRef, useState } from 'react'
import {
  createAdminQuestion,
  deleteAdminQuestion,
  listAdminQuestions,
  updateAdminQuestion,
} from '../api/adminQuestions'
import AdminTabs from '../components/AdminTabs'
import Breadcrumb from '../components/Breadcrumb'
import ConfirmDialog from '../components/ConfirmDialog'
import Icon from '../components/Icon'
import Pagination from '../components/Pagination'
import { apiErrorMessage } from '../constants/scoring'
import { INDUSTRIES, LEVELS, levelOf, QUESTION_TYPES, questionContext, questionTypeLabel } from '../constants/taxonomy'
import styles from './AdminQuestionsPage.module.css'

const PAGE_SIZE = 10
const DEBOUNCE_MS = 400
const OUT_OF_TAXONOMY = ' (ngoài danh mục)'
const STATUS_OPTIONS = [
  { value: '', label: 'Tất cả' },
  { value: 'ACTIVE', label: 'Đang hiển thị' },
  { value: 'HIDDEN', label: 'Đã ẩn' },
]
const EMPTY_FORM = {
  content: '',
  industry: '',
  position: '',
  level: 'EASY',
  questionType: 'BEHAVIORAL',
  answerHint: '',
  referenceAnswer: '',
}

// Lỗi ghi (POST/PUT/DELETE) -> câu tiếng Việt rõ ràng; 400 có fieldErrors thì hiện dưới trường
function writeErrorMessage(err) {
  if (err.status === 409) return 'Câu hỏi này đã tồn tại trong ngân hàng (trùng nội dung, ngành và vị trí).'
  if (err.status === 404) return 'Câu hỏi không còn tồn tại (có thể đã bị xoá). Danh sách sẽ được tải lại.'
  if (err.status === 400 && err.fieldErrors.length > 0) return 'Vui lòng kiểm tra lại các trường được đánh dấu.'
  return apiErrorMessage(err)
}

export default function AdminQuestionsPage() {
  const [status, setStatus] = useState('')
  const [keywordInput, setKeywordInput] = useState('')
  const [keyword, setKeyword] = useState('')
  const [page, setPage] = useState(0)
  const [reloadKey, setReloadKey] = useState(0)
  const [result, setResult] = useState({ key: null, data: null, error: null })
  const [form, setForm] = useState(null) // null = đóng; { id, values } = đang thêm (id null) / sửa
  const [toDelete, setToDelete] = useState(null)
  const [notice, setNotice] = useState(null)
  const formAnchor = useRef(null)

  const key = `${status}|${keyword}|${page}|${reloadKey}`

  useEffect(() => {
    const timer = setTimeout(() => {
      const next = keywordInput.trim()
      setKeyword((prev) => {
        if (prev !== next) setPage(0)
        return next
      })
    }, DEBOUNCE_MS)
    return () => clearTimeout(timer)
  }, [keywordInput])

  useEffect(() => {
    let cancelled = false
    listAdminQuestions({ status, keyword, page, size: PAGE_SIZE })
      .then((data) => {
        if (cancelled) return
        // Sau khi xoá hết trang cuối: lùi đúng một trang
        if (data.content.length === 0 && page > 0) setPage(page - 1)
        else setResult({ key, data, error: null })
      })
      .catch((error) => !cancelled && setResult({ key, data: null, error }))
    return () => {
      cancelled = true
    }
  }, [status, keyword, page, key])

  const loading = result.key !== key
  const data = result.data
  const total = data?.totalElements ?? 0

  function openForm(question) {
    setNotice(null)
    setForm(
      question
        ? {
            id: question.id,
            values: {
              content: question.content,
              industry: question.industry,
              position: question.position,
              level: question.level,
              questionType: question.questionType,
              answerHint: question.answerHint ?? '',
              referenceAnswer: question.referenceAnswer ?? '',
            },
          }
        : { id: null, values: EMPTY_FORM },
    )
    setTimeout(() => formAnchor.current?.scrollIntoView({ behavior: 'smooth', block: 'start' }), 0)
  }

  function onSaved(message) {
    setForm(null)
    setNotice(message)
    setReloadKey((k) => k + 1)
  }

  return (
    <div className="container page">
      <Breadcrumb current="Quản trị" />
      <div className={styles.titleRow}>
        <div>
          <h1 className="page-title">Quản trị câu hỏi</h1>
          <p className="page-sub">Thêm, sửa và xoá câu hỏi trong ngân hàng.</p>
        </div>
        <button type="button" className="btn btn-primary" onClick={() => openForm(null)} disabled={form?.id === null}>
          <Icon name="plus" size={14} />
          Thêm câu hỏi
        </button>
      </div>

      <AdminTabs />

      <div ref={formAnchor}>
        {form && (
          <QuestionForm
            key={form.id ?? 'new'}
            id={form.id}
            initial={form.values}
            onCancel={() => setForm(null)}
            onSaved={onSaved}
            onGone={() => setReloadKey((k) => k + 1)}
          />
        )}
      </div>

      {notice && (
        <p role="status" className={`alert alert-success ${styles.alert}`}>
          {notice}
        </p>
      )}

      <section className={`card ${styles.filters}`}>
        <label className="field">
          <span className={styles.label}>Từ khoá</span>
          <input
            type="search"
            className="input"
            maxLength={200}
            value={keywordInput}
            onChange={(e) => setKeywordInput(e.target.value)}
            placeholder="Tìm trong nội dung câu hỏi..."
          />
        </label>
        <label className="field">
          <span className={styles.label}>Trạng thái</span>
          <select
            className="select"
            value={status}
            onChange={(e) => {
              setStatus(e.target.value)
              setPage(0)
            }}
          >
            {STATUS_OPTIONS.map((o) => (
              <option key={o.value} value={o.value}>
                {o.label}
              </option>
            ))}
          </select>
        </label>
      </section>

      {result.error && !loading && (
        <p role="alert" className={`alert ${styles.alert}`}>
          Không tải được danh sách câu hỏi: {apiErrorMessage(result.error)}
        </p>
      )}

      {loading && !data && (
        <p className={styles.state} role="status">
          Đang tải...
        </p>
      )}

      {data && data.content.length === 0 && (
        <section className={`card ${styles.empty}`}>
          <h3>Không có câu hỏi nào</h3>
          <p>
            {keyword || status
              ? 'Thử đổi từ khoá hoặc bộ lọc trạng thái.'
              : 'Ngân hàng chưa có câu hỏi. Hãy thêm câu hỏi đầu tiên.'}
          </p>
        </section>
      )}

      {data && data.content.length > 0 && (
        <>
          <div className={`${styles.tableWrap} ${loading ? styles.loading : ''}`}>
            <table className={styles.table}>
              <thead>
                <tr>
                  <th scope="col">Câu hỏi</th>
                  <th scope="col">Ngành · Vị trí</th>
                  <th scope="col">Loại</th>
                  <th scope="col">Mức</th>
                  <th scope="col">Trạng thái</th>
                  <th scope="col">
                    <span className="visually-hidden">Thao tác</span>
                  </th>
                </tr>
              </thead>
              <tbody>
                {data.content.map((q) => (
                  <tr key={q.id}>
                    <td data-label="Câu hỏi" className={styles.contentCell}>
                      {q.content}
                    </td>
                    <td data-label="Ngành · Vị trí">{questionContext(q)}</td>
                    <td data-label="Loại">{questionTypeLabel(q.questionType)}</td>
                    <td data-label="Mức">{levelOf(q.level)?.label ?? q.level}</td>
                    <td data-label="Trạng thái">
                      {q.status === 'HIDDEN' ? (
                        <span className="pill pill-gray">Đã ẩn</span>
                      ) : (
                        <span className="pill pill-green">Đang hiển thị</span>
                      )}
                    </td>
                    <td className={styles.actions}>
                      <button type="button" className="btn btn-outline btn-sm" onClick={() => openForm(q)}>
                        Sửa
                      </button>
                      <button
                        type="button"
                        className="btn btn-outline btn-sm"
                        onClick={() => {
                          setNotice(null)
                          setToDelete(q)
                        }}
                      >
                        Xoá
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <div className={styles.pagination}>
            <Pagination
              page={data.page ?? page}
              totalPages={data.totalPages ?? 0}
              onChange={setPage}
              summary={`Hiển thị ${(data.page ?? 0) * PAGE_SIZE + 1}–${Math.min(total, ((data.page ?? 0) + 1) * PAGE_SIZE)} trên ${total.toLocaleString('vi-VN')} câu hỏi`}
              aside={`${PAGE_SIZE} / trang`}
            />
          </div>
        </>
      )}

      {toDelete && (
        <DeleteDialog
          question={toDelete}
          onCancel={() => setToDelete(null)}
          onDeleted={() => {
            setToDelete(null)
            setNotice('Đã xoá câu hỏi.')
            setReloadKey((k) => k + 1)
          }}
          onGone={() => {
            setToDelete(null)
            setReloadKey((k) => k + 1)
          }}
        />
      )}
    </div>
  )
}

function DeleteDialog({ question, onCancel, onDeleted, onGone }) {
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState(null)

  async function confirm() {
    if (busy) return
    setBusy(true)
    setError(null)
    try {
      await deleteAdminQuestion(question.id)
      onDeleted()
    } catch (err) {
      if (err.status === 404) onGone()
      else {
        setError(writeErrorMessage(err))
        setBusy(false)
      }
    }
  }

  return (
    <ConfirmDialog
      title="Xoá câu hỏi?"
      message={`“${question.content}” — câu hỏi đã có người luyện sẽ chỉ bị ẩn khỏi danh sách luyện tập, chưa từng được dùng sẽ bị xoá hẳn.`}
      confirmLabel="Xoá câu hỏi"
      busy={busy}
      error={error}
      onConfirm={confirm}
      onCancel={onCancel}
    />
  )
}

function QuestionForm({ id, initial, onCancel, onSaved, onGone }) {
  const [values, setValues] = useState(initial)
  const [submitting, setSubmitting] = useState(false)
  const [error, setError] = useState(null)
  const [fieldErrors, setFieldErrors] = useState({})

  const industryKnown = INDUSTRIES.some((i) => i.value === values.industry)
  const positions = INDUSTRIES.find((i) => i.value === values.industry)?.positions ?? []
  // Câu cũ ngoài taxonomy: giữ giá trị hiện có bằng option tạm để không bị mất khi chưa sửa
  const positionKnown = positions.includes(values.position)
  const isTechnical = values.questionType === 'TECHNICAL'

  function set(field, value) {
    setValues((v) => ({ ...v, [field]: value }))
    setFieldErrors((e) => ({ ...e, [field]: undefined }))
  }

  async function submit(e) {
    e.preventDefault()
    if (submitting) return
    setSubmitting(true)
    setError(null)
    setFieldErrors({})
    const body = {
      content: values.content.trim(),
      industry: values.industry,
      position: values.position,
      level: values.level,
      questionType: values.questionType,
      answerHint: values.answerHint.trim(),
      ...(isTechnical ? { referenceAnswer: values.referenceAnswer.trim() } : {}),
    }
    try {
      if (id === null) await createAdminQuestion(body)
      else await updateAdminQuestion(id, body)
      onSaved(id === null ? 'Đã thêm câu hỏi.' : 'Đã lưu thay đổi.')
    } catch (err) {
      if (err.status === 404) onGone()
      setError(writeErrorMessage(err))
      setFieldErrors(Object.fromEntries((err.fieldErrors ?? []).map((f) => [f.field, f.message])))
      setSubmitting(false)
    }
  }

  return (
    <form className={`card ${styles.form}`} onSubmit={submit} aria-labelledby="question-form-title" noValidate>
      <h2 id="question-form-title" className={styles.formTitle}>
        {id === null ? 'Thêm câu hỏi' : 'Sửa câu hỏi'}
      </h2>
      {error && (
        <p role="alert" className="alert">
          {error}
        </p>
      )}

      <FormField label="Nội dung câu hỏi" error={fieldErrors.content}>
        {(p) => (
          <textarea
            {...p}
            className="textarea"
            rows={3}
            value={values.content}
            onChange={(e) => set('content', e.target.value)}
            required
          />
        )}
      </FormField>

      <div className={styles.formGrid}>
        <FormField label="Ngành" error={fieldErrors.industry}>
          {(p) => (
            <select
              {...p}
              className="select"
              value={values.industry}
              onChange={(e) => {
                set('industry', e.target.value)
                set('position', '')
              }}
              required
            >
              <option value="">Chọn ngành</option>
              {!industryKnown && values.industry && (
                <option value={values.industry}>{values.industry + OUT_OF_TAXONOMY}</option>
              )}
              {INDUSTRIES.map((i) => (
                <option key={i.value} value={i.value}>
                  {i.value}
                </option>
              ))}
            </select>
          )}
        </FormField>
        <FormField label="Vị trí" error={fieldErrors.position}>
          {(p) => (
            <select
              {...p}
              className="select"
              value={values.position}
              onChange={(e) => set('position', e.target.value)}
              disabled={!values.industry}
              required
            >
              <option value="">Chọn vị trí</option>
              {!positionKnown && values.position && (
                <option value={values.position}>{values.position + OUT_OF_TAXONOMY}</option>
              )}
              {positions.map((pos) => (
                <option key={pos} value={pos}>
                  {pos}
                </option>
              ))}
            </select>
          )}
        </FormField>
        <FormField label="Loại câu hỏi" error={fieldErrors.questionType}>
          {(p) => (
            <select
              {...p}
              className="select"
              value={values.questionType}
              onChange={(e) => set('questionType', e.target.value)}
            >
              {QUESTION_TYPES.map((t) => (
                <option key={t.value} value={t.value}>
                  {t.label}
                </option>
              ))}
            </select>
          )}
        </FormField>
        <FormField label="Mức độ" error={fieldErrors.level}>
          {(p) => (
            <select {...p} className="select" value={values.level} onChange={(e) => set('level', e.target.value)}>
              {LEVELS.map((l) => (
                <option key={l.value} value={l.value}>
                  {l.label}
                </option>
              ))}
            </select>
          )}
        </FormField>
      </div>

      <FormField label="Gợi ý trả lời (không bắt buộc)" error={fieldErrors.answerHint}>
        {(p) => (
          <textarea
            {...p}
            className="textarea"
            rows={2}
            value={values.answerHint}
            onChange={(e) => set('answerHint', e.target.value)}
          />
        )}
      </FormField>

      {isTechnical && (
        <FormField label="Đáp án tham chiếu (các ý chính cần có)" error={fieldErrors.referenceAnswer}>
          {(p) => (
            <textarea
              {...p}
              className="textarea"
              rows={4}
              value={values.referenceAnswer}
              onChange={(e) => set('referenceAnswer', e.target.value)}
            />
          )}
        </FormField>
      )}

      <div className={styles.formActions}>
        <button type="button" className="btn btn-outline" onClick={onCancel} disabled={submitting}>
          Huỷ
        </button>
        <button type="submit" className="btn btn-primary" disabled={submitting}>
          {submitting ? 'Đang lưu...' : 'Lưu'}
        </button>
      </div>
    </form>
  )
}

// children là hàm nhận props a11y (id, aria-invalid, aria-describedby) để gắn lỗi đúng trường
function FormField({ label, error, children }) {
  const [uid] = useState(() => `qf-${Math.random().toString(36).slice(2, 9)}`)
  const props = {
    id: uid,
    'aria-invalid': error ? true : undefined,
    'aria-describedby': error ? `${uid}-err` : undefined,
  }
  return (
    <div className="field">
      <label className="label" htmlFor={uid}>
        {label}
      </label>
      {children(props)}
      {error && (
        <span id={`${uid}-err`} className="field-error">
          {error}
        </span>
      )}
    </div>
  )
}
