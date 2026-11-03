import { useEffect, useState } from 'react'
import { useSearchParams } from 'react-router'
import { listQuestions, randomQuestion } from '../api/questions'
import Breadcrumb from '../components/Breadcrumb'
import Icon from '../components/Icon'
import Pagination from '../components/Pagination'
import { MAX_RECORDING_SECONDS } from '../constants/practice'
import { INDUSTRIES, LEVELS, levelOf, QUESTION_TYPES, questionContext, questionTypeLabel } from '../constants/taxonomy'
import { useStartPractice } from '../hooks/useStartPractice'
import styles from './QuestionsPage.module.css'

const PAGE_SIZE = 6
const FILTER_KEYS = ['industry', 'position', 'level', 'questionType', 'keyword']

function readFilters(searchParams) {
  const filters = Object.fromEntries(FILTER_KEYS.map((k) => [k, searchParams.get(k) || '']))
  filters.page = Math.max(0, Number(searchParams.get('page')) || 0)
  return filters
}

export default function QuestionsPage() {
  const [searchParams, setSearchParams] = useSearchParams()
  const filters = readFilters(searchParams)
  const filtersKey = searchParams.toString()
  const { start, startingId, error: startError } = useStartPractice()

  const [keywordInput, setKeywordInput] = useState(filters.keyword)
  // key = bộ lọc của lần tải gần nhất; khác filtersKey nghĩa là đang tải bộ lọc mới
  const [result, setResult] = useState({ key: null, data: null, error: null })
  const [randomError, setRandomError] = useState(null)

  useEffect(() => {
    let cancelled = false
    const current = readFilters(new URLSearchParams(filtersKey))
    listQuestions({ ...current, size: PAGE_SIZE })
      .then((data) => !cancelled && setResult({ key: filtersKey, data, error: null }))
      .catch((error) => !cancelled && setResult({ key: filtersKey, data: null, error }))
    return () => {
      cancelled = true
    }
  }, [filtersKey])

  // Đổi bộ lọc thì quay về trang đầu; đổi ngành thì bỏ vị trí cũ vì vị trí phụ thuộc ngành
  function updateFilters(changes) {
    const next = { ...filters, ...changes }
    if ('industry' in changes && changes.industry !== filters.industry) next.position = ''
    const params = new URLSearchParams()
    for (const key of FILTER_KEYS) if (next[key]) params.set(key, next[key])
    setSearchParams(params)
  }

  function goToPage(page) {
    const params = new URLSearchParams(searchParams)
    if (page > 0) params.set('page', String(page))
    else params.delete('page')
    setSearchParams(params)
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }

  function clearAll() {
    setKeywordInput('')
    setSearchParams(new URLSearchParams())
  }

  // UC3 Alt 5a: lấy ngẫu nhiên một câu theo bộ lọc (scope = 'industry' chỉ giữ ngành)
  async function practiceRandom(scope) {
    setRandomError(null)
    const criteria = scope === 'industry' ? { industry: filters.industry } : filters
    await start(async () => (await randomQuestion(criteria)).id, 'random').catch((err) =>
      setRandomError(err.status === 404 ? 'Không có câu hỏi nào phù hợp bộ lọc hiện tại.' : err.message),
    )
  }

  const positions = INDUSTRIES.find((i) => i.value === filters.industry)?.positions ?? []
  const loading = result.key !== filtersKey
  const page = result.data
  const total = page?.totalElements ?? 0
  const hasFilters = FILTER_KEYS.some((k) => filters[k])
  const actionError = startError || randomError

  return (
    <div className="container page">
      <Breadcrumb current="Ngân hàng câu hỏi" />

      <div className={styles.titleRow}>
        <div>
          <h1 className="page-title">Ngân hàng câu hỏi</h1>
          <p className="page-sub">
            Chọn câu hỏi theo ngành và vị trí bạn ứng tuyển, ghi âm câu trả lời và nhận chấm điểm theo rubric.
          </p>
        </div>
        <button type="button" className="btn btn-outline" onClick={() => practiceRandom()} disabled={startingId !== null}>
          <span aria-hidden>🎲</span>
          {startingId === 'random' ? 'Đang chuẩn bị...' : 'Chọn ngẫu nhiên'}
        </button>
      </div>

      <section className={`card ${styles.filters}`}>
        <form
          className={styles.searchRow}
          role="search"
          onSubmit={(e) => {
            e.preventDefault()
            updateFilters({ keyword: keywordInput.trim() })
          }}
        >
          <label className={styles.searchBox}>
            <Icon name="search" size={13} strokeWidth={2} className={styles.searchIcon} />
            <span className="visually-hidden">Từ khoá</span>
            <input
              type="search"
              value={keywordInput}
              onChange={(e) => setKeywordInput(e.target.value)}
              placeholder="Tìm theo từ khóa, ví dụ: xung đột nhóm, REST API, deadline..."
            />
          </label>
          <button type="submit" className="btn btn-primary">
            Tìm kiếm
          </button>
        </form>

        <div className={styles.group}>
          <span className={styles.groupLabel}>Ngành nghề</span>
          <div className={styles.chips}>
            <Chip active={!filters.industry} onClick={() => updateFilters({ industry: '' })}>
              Tất cả
            </Chip>
            {INDUSTRIES.map((industry) => (
              <Chip
                key={industry.value}
                active={filters.industry === industry.value}
                onClick={() => updateFilters({ industry: industry.value })}
              >
                {industry.value}
              </Chip>
            ))}
          </div>
        </div>

        <div className={styles.selects}>
          <label className="field">
            <span className={styles.groupLabel}>Vị trí</span>
            <select
              className="select"
              value={filters.position}
              onChange={(e) => updateFilters({ position: e.target.value })}
              disabled={!filters.industry}
              title={filters.industry ? undefined : 'Chọn ngành nghề trước'}
            >
              <option value="">Tất cả</option>
              {positions.map((p) => (
                <option key={p} value={p}>
                  {p}
                </option>
              ))}
            </select>
          </label>
          <label className="field">
            <span className={styles.groupLabel}>Độ khó</span>
            <select className="select" value={filters.level} onChange={(e) => updateFilters({ level: e.target.value })}>
              <option value="">Tất cả</option>
              {LEVELS.map((l) => (
                <option key={l.value} value={l.value}>
                  {l.label}
                </option>
              ))}
            </select>
          </label>
          <label className="field">
            <span className={styles.groupLabel}>Loại câu hỏi</span>
            <select
              className="select"
              value={filters.questionType}
              onChange={(e) => updateFilters({ questionType: e.target.value })}
            >
              <option value="">Tất cả</option>
              {QUESTION_TYPES.map((t) => (
                <option key={t.value} value={t.value}>
                  {t.label}
                </option>
              ))}
            </select>
          </label>
          <button type="button" className={`link ${styles.clear}`} onClick={clearAll} disabled={!hasFilters}>
            Xóa bộ lọc
          </button>
        </div>
      </section>

      <div className={styles.listHeader}>
        <div>
          <h2 className={styles.listTitle}>
            {loading && !page ? 'Đang tải...' : `${total.toLocaleString('vi-VN')} câu hỏi`}
            {filters.industry && ` · ${filters.industry}`}
            {filters.position && ` › ${filters.position}`}
          </h2>
          <p className={styles.listSub}>{listSubtitle(filters)}</p>
        </div>
        <label className={styles.sort}>
          Sắp xếp:
          {/* API chưa có tham số sắp xếp, danh sách theo thứ tự mặc định của server */}
          <select className={styles.sortSelect} defaultValue="newest">
            <option value="newest">Mới nhất</option>
          </select>
        </label>
      </div>

      {actionError && (
        <p role="alert" className={`alert ${styles.alert}`}>
          {actionError}
        </p>
      )}
      {result.error && !loading && (
        <p role="alert" className={`alert ${styles.alert}`}>
          Không tải được danh sách câu hỏi: {result.error.message}
        </p>
      )}

      {page && page.content?.length === 0 && (
        <section className={`card ${styles.empty}`}>
          <span className={styles.emptyEmoji} aria-hidden>
            🔍
          </span>
          <h3>Không tìm thấy câu hỏi phù hợp</h3>
          <p>{emptyMessage(filters)}</p>
          <div className={styles.emptyActions}>
            <button type="button" className="btn btn-outline" onClick={clearAll}>
              Xoá bộ lọc
            </button>
            <button
              type="button"
              className="btn btn-primary"
              onClick={() => practiceRandom('industry')}
              disabled={startingId !== null}
            >
              {filters.industry ? 'Chọn ngẫu nhiên trong ngành' : 'Chọn ngẫu nhiên'}
            </button>
          </div>
        </section>
      )}

      {page && page.content?.length > 0 && (
        <>
          <div className={`${styles.grid} ${loading ? styles.gridLoading : ''}`}>
            {page.content.map((q) => (
              <QuestionCard
                key={q.id}
                question={q}
                starting={startingId === q.id}
                disabled={startingId !== null}
                onPractice={() => start(q.id)}
              />
            ))}
          </div>
          <div className={styles.pagination}>
            <Pagination
              page={page.page ?? filters.page}
              totalPages={page.totalPages ?? 0}
              onChange={goToPage}
              summary={`Hiển thị ${(page.page ?? 0) * PAGE_SIZE + 1}–${Math.min(total, ((page.page ?? 0) + 1) * PAGE_SIZE)} trên ${total.toLocaleString('vi-VN')} câu hỏi`}
              aside={`${PAGE_SIZE} / trang`}
            />
          </div>
        </>
      )}
    </div>
  )
}

function listSubtitle(filters) {
  const extra = [levelOf(filters.level)?.label, filters.questionType && questionTypeLabel(filters.questionType)]
    .filter(Boolean)
    .join(' · ')
  if (extra) return `Đang lọc: ${extra}`
  if (filters.position && filters.position !== 'Chung')
    return `Bao gồm cả câu hỏi “Chung” của ngành ${filters.industry} (hành vi, tình huống, giới thiệu bản thân).`
  if (filters.keyword) return `Kết quả cho “${filters.keyword}”`
  return filters.industry ? `Tất cả vị trí trong ngành ${filters.industry}` : 'Tất cả ngành nghề'
}

function emptyMessage(filters) {
  const parts = []
  if (filters.questionType) parts.push(questionTypeLabel(filters.questionType))
  if (filters.level) parts.push(`mức ${levelOf(filters.level)?.label}`)
  const target = filters.position || filters.industry
  const subject = parts.length ? `câu hỏi ${parts.join(' ')}` : 'câu hỏi'
  return `Chưa có ${subject}${target ? ` cho vị trí ${target}` : ' phù hợp'}. Thử bỏ bớt bộ lọc hoặc đổi từ khoá.`
}

function Chip({ active, onClick, children }) {
  return (
    <button
      type="button"
      className={`${styles.chip} ${active ? styles.chipActive : ''}`}
      onClick={onClick}
      aria-pressed={active}
    >
      {children}
    </button>
  )
}

function QuestionCard({ question, starting, disabled, onPractice }) {
  const level = levelOf(question.level)
  return (
    <article className={styles.card}>
      <div className={styles.cardTop}>
        <span className="pill pill-gray">{questionTypeLabel(question.questionType)}</span>
        {level && <span className={`pill ${level.pill}`}>{level.label}</span>}
      </div>
      <h3 className={styles.cardTitle} title={question.content}>
        {question.content}
      </h3>
      <p className={styles.cardMeta}>{questionContext(question)}</p>
      {question.answerHint && <p className={styles.cardHint}>{question.answerHint}</p>}
      <div className={styles.cardFooter}>
        <span className={styles.duration}>
          <Icon name="clock" size={13} />
          Tối đa {MAX_RECORDING_SECONDS / 60} phút
        </span>
        <button type="button" className="btn btn-primary" onClick={onPractice} disabled={disabled}>
          {starting ? 'Đang tạo...' : 'Luyện tập'}
        </button>
      </div>
    </article>
  )
}
