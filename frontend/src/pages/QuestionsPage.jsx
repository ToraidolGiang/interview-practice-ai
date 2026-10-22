import { useEffect, useState } from 'react'
import { useNavigate, useSearchParams } from 'react-router'
import iconBars from '../assets/figma/icon-bars.svg'
import iconBolt from '../assets/figma/icon-bolt.svg'
import iconBreadcrumbChevron from '../assets/figma/icon-breadcrumb-chevron.svg'
import iconBuilding from '../assets/figma/icon-building.svg'
import iconCloseSmall from '../assets/figma/icon-close-small.svg'
import iconFormat from '../assets/figma/icon-format.svg'
import iconGrid from '../assets/figma/icon-grid.svg'
import iconHome from '../assets/figma/icon-home.svg'
import iconCskh from '../assets/figma/icon-industry-cskh.svg'
import iconFinance from '../assets/figma/icon-industry-finance.svg'
import iconHr from '../assets/figma/icon-industry-hr.svg'
import iconIt from '../assets/figma/icon-industry-it.svg'
import iconMarketing from '../assets/figma/icon-industry-marketing.svg'
import iconMicWhite from '../assets/figma/icon-mic-white.svg'
import iconReset from '../assets/figma/icon-reset.svg'
import iconSearchWhite from '../assets/figma/icon-search-white.svg'
import iconSearch from '../assets/figma/icon-search.svg'
import iconSliders from '../assets/figma/icon-sliders.svg'
import iconTrendDark from '../assets/figma/icon-trend-dark.svg'
import { createPracticeSession } from '../api/practice'
import { listQuestions, randomQuestion } from '../api/questions'
import Pagination from '../components/Pagination'
import {
  INDUSTRIES,
  industryLabel,
  LEVELS,
  levelOf,
  QUESTION_TYPES,
  questionTypeLabel,
} from '../constants/taxonomy'
import styles from './QuestionsPage.module.css'

const PAGE_SIZE = 6
const FILTER_KEYS = ['industry', 'position', 'level', 'questionType', 'keyword']
const SEARCH_SUGGESTIONS = ['Tình huống khó', 'Lãnh đạo', 'Microservices', 'Xung đột nhóm', 'Quản lý ngân sách']

const INDUSTRY_ICONS = {
  IT: iconIt,
  Marketing: iconMarketing,
  'Kinh doanh / Bán hàng': iconTrendDark,
  'Kế toán / Tài chính': iconFinance,
  'Nhân sự': iconHr,
  'Chăm sóc khách hàng': iconCskh,
}

function readFilters(searchParams) {
  const filters = Object.fromEntries(FILTER_KEYS.map((k) => [k, searchParams.get(k) || '']))
  filters.page = Math.max(0, Number(searchParams.get('page')) || 0)
  return filters
}

export default function QuestionsPage() {
  const navigate = useNavigate()
  const [searchParams, setSearchParams] = useSearchParams()
  const filters = readFilters(searchParams)
  const filtersKey = searchParams.toString()

  const [keywordInput, setKeywordInput] = useState(filters.keyword)
  // key = bộ lọc của lần tải gần nhất; khác filtersKey nghĩa là đang tải bộ lọc mới
  const [result, setResult] = useState({ key: null, data: null, error: null })
  const [actionError, setActionError] = useState(null)
  const [startingId, setStartingId] = useState(null)

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
    const next = { ...filters, ...changes, page: 0 }
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

  function submitSearch(e) {
    e.preventDefault()
    updateFilters({ keyword: keywordInput.trim() })
  }

  function clearAll() {
    setKeywordInput('')
    setSearchParams(new URLSearchParams())
  }

  async function startPractice(questionId) {
    setActionError(null)
    setStartingId(questionId)
    try {
      const session = await createPracticeSession(questionId)
      navigate(`/practice/${session.id}`, { state: { questionId } })
    } catch (error) {
      setActionError(
        error.status === 404 ? 'Câu hỏi không còn khả dụng, vui lòng chọn câu khác.' : error.message,
      )
      setStartingId(null)
    }
  }

  async function practiceRandom() {
    setActionError(null)
    setStartingId('random')
    try {
      const question = await randomQuestion(filters)
      await startPractice(question.id)
    } catch (error) {
      setActionError(
        error.status === 404 ? 'Không có câu hỏi nào phù hợp bộ lọc hiện tại.' : error.message,
      )
      setStartingId(null)
    }
  }

  const positions = INDUSTRIES.find((i) => i.value === filters.industry)?.positions ?? []
  const activeChips = [
    filters.keyword && { key: 'keyword', label: `Từ khóa: ${filters.keyword}` },
    filters.industry && { key: 'industry', label: `Ngành: ${industryLabel(filters.industry)}` },
    filters.position && { key: 'position', label: `Vị trí: ${filters.position}` },
    filters.level && { key: 'level', label: `Độ khó: ${levelOf(filters.level)?.label}` },
    filters.questionType && {
      key: 'questionType',
      label: `Định dạng: ${questionTypeLabel(filters.questionType)}`,
    },
  ].filter(Boolean)

  const loading = result.key !== filtersKey
  const status = loading ? 'loading' : result.error ? 'error' : 'ready'
  const page = result.data
  const total = page?.totalElements ?? 0

  return (
    <div className={styles.page}>
      <nav className={styles.breadcrumb} aria-label="Breadcrumb">
        <img src={iconHome} alt="" width="10.6667" height="12" />
        <span>Ứng viên</span>
        <img src={iconBreadcrumbChevron} alt="" width="4.31667" height="7" />
        <span className={styles.breadcrumbCurrent}>Ngân hàng câu hỏi</span>
      </nav>

      <div className={styles.titleRow}>
        <h1 className={styles.title}>Ngân hàng câu hỏi phỏng vấn thực tế</h1>
        <button
          type="button"
          className={styles.randomButton}
          onClick={practiceRandom}
          disabled={startingId !== null}
        >
          <img src={iconMicWhite} alt="" width="9.33333" height="12.6667" />
          {startingId === 'random' ? 'Đang chuẩn bị...' : 'Luyện câu ngẫu nhiên'}
        </button>
      </div>

      <section className={styles.filterCard}>
        <form className={styles.searchBox} onSubmit={submitSearch} role="search">
          <img className={styles.searchIcon} src={iconSearch} alt="" width="16.5" height="16.5" />
          <input
            className={styles.searchInput}
            type="search"
            value={keywordInput}
            onChange={(e) => setKeywordInput(e.target.value)}
            placeholder="Tìm kiếm theo từ khóa, kỹ năng (ví dụ: Xử lý mâu thuẫn, System Design, ROI marketing, STAR...)"
            aria-label="Từ khóa"
          />
          <span className={styles.enterHint} aria-hidden>
            Enter ↵
          </span>
          <button type="submit" className={styles.searchButton}>
            <img src={iconSearchWhite} alt="" width="13.5" height="13.5" />
            Tìm kiếm
          </button>
        </form>

        <div className={styles.suggestions}>
          <img src={iconTrendDark} alt="" width="12.5" height="7.5" />
          <span>Gợi ý tìm kiếm:</span>
          {SEARCH_SUGGESTIONS.map((s) => (
            <button
              key={s}
              type="button"
              className={styles.suggestion}
              onClick={() => {
                setKeywordInput(s)
                updateFilters({ keyword: s })
              }}
            >
              {s}
            </button>
          ))}
        </div>

        <hr className={styles.separator} />

        <div className={styles.industryRow}>
          <span className={styles.groupLabel}>
            <img src={iconBuilding} alt="" width="15" height="13.5" />
            Ngành nghề:
          </span>
          <div className={styles.industryChips}>
            <IndustryChip
              icon={iconGrid}
              iconSize={[10.6667, 10.6667]}
              label="Tất cả"
              count={!filters.industry && status === 'ready' ? total : undefined}
              active={!filters.industry}
              onClick={() => updateFilters({ industry: '' })}
            />
            {INDUSTRIES.map((industry) => (
              <IndustryChip
                key={industry.value}
                icon={INDUSTRY_ICONS[industry.value]}
                label={industry.label}
                count={filters.industry === industry.value && status === 'ready' ? total : undefined}
                active={filters.industry === industry.value}
                onClick={() => updateFilters({ industry: industry.value })}
              />
            ))}
          </div>
        </div>

        <div className={styles.filterGrid}>
          <label className={styles.filterField}>
            <span className={styles.fieldLabel}>
              <img src={iconBars} alt="" width="10" height="10.6667" />
              Vị trí ứng tuyển:
            </span>
            <select
              className={styles.select}
              value={filters.position}
              onChange={(e) => updateFilters({ position: e.target.value })}
              disabled={!filters.industry}
              title={filters.industry ? undefined : 'Chọn ngành nghề trước'}
            >
              <option value="">{filters.industry ? 'Tất cả vị trí' : 'Chọn ngành trước'}</option>
              {positions.map((p) => (
                <option key={p} value={p}>
                  {p}
                </option>
              ))}
            </select>
          </label>

          <div className={styles.filterField}>
            <span className={styles.fieldLabel}>
              <img src={iconBolt} alt="" width="10.6667" height="13.3333" />
              Mức độ khó:
            </span>
            <div className={styles.segmented} role="radiogroup" aria-label="Mức độ khó">
              <SegmentButton active={!filters.level} onClick={() => updateFilters({ level: '' })}>
                Tất cả
              </SegmentButton>
              {LEVELS.map((level) => (
                <SegmentButton
                  key={level.value}
                  tone={level.value}
                  active={filters.level === level.value}
                  onClick={() => updateFilters({ level: level.value })}
                >
                  {level.label}
                </SegmentButton>
              ))}
            </div>
          </div>

          <label className={styles.filterField}>
            <span className={styles.fieldLabel}>
              <img src={iconFormat} alt="" width="13.3333" height="13.3333" />
              Định dạng phỏng vấn:
            </span>
            <select
              className={styles.select}
              value={filters.questionType}
              onChange={(e) => updateFilters({ questionType: e.target.value })}
            >
              <option value="">Tất cả định dạng</option>
              {QUESTION_TYPES.map((t) => (
                <option key={t.value} value={t.value}>
                  {t.label}
                </option>
              ))}
            </select>
          </label>
        </div>

        <hr className={styles.separator} />

        <div className={styles.activeRow}>
          <div className={styles.activeChips}>
            <span className={styles.activeLabel}>
              <img src={iconSliders} alt="" width="12" height="12" />
              {activeChips.length ? `Đang áp dụng ${activeChips.length} bộ lọc:` : 'Chưa áp dụng bộ lọc'}
            </span>
            {activeChips.map((chip) => (
              <span key={chip.key} className={styles.activeChip}>
                {chip.label}
                <button
                  type="button"
                  aria-label={`Bỏ lọc ${chip.label}`}
                  onClick={() => {
                    if (chip.key === 'keyword') setKeywordInput('')
                    updateFilters({ [chip.key]: '' })
                  }}
                >
                  <img src={iconCloseSmall} alt="" width="8.16667" height="8.16667" />
                </button>
              </span>
            ))}
          </div>
          {activeChips.length > 0 && (
            <button type="button" className={styles.clearButton} onClick={clearAll}>
              <img src={iconReset} alt="" width="10.6667" height="12.3" />
              Xóa tất cả bộ lọc
            </button>
          )}
        </div>
      </section>

      <div className={styles.listHeader}>
        <h2 className={styles.listTitle}>Danh sách câu hỏi tuyển dụng</h2>
        {status === 'ready' && (
          <span className={styles.countBadge}>{total.toLocaleString('vi-VN')} CÂU</span>
        )}
      </div>

      {actionError && (
        <p role="alert" className={styles.alert}>
          {actionError}
        </p>
      )}

      {status === 'error' && (
        <p role="alert" className={styles.alert}>
          Không tải được danh sách câu hỏi: {result.error.message}
        </p>
      )}

      {status === 'loading' && !page && <p className={styles.empty}>Đang tải câu hỏi...</p>}

      {page && page.content?.length === 0 && (
        <p className={styles.empty}>Không có câu hỏi phù hợp. Thử bỏ bớt bộ lọc hoặc đổi từ khóa.</p>
      )}

      {page && page.content?.length > 0 && (
        <>
          <div className={`${styles.grid} ${status === 'loading' ? styles.gridLoading : ''}`}>
            {page.content.map((q) => (
              <QuestionCard
                key={q.id}
                question={q}
                starting={startingId === q.id}
                disabled={startingId !== null}
                onPractice={() => startPractice(q.id)}
              />
            ))}
          </div>
          <Pagination
            page={page.page ?? filters.page}
            size={page.size ?? PAGE_SIZE}
            totalElements={total}
            totalPages={page.totalPages ?? 0}
            itemLabel="câu hỏi"
            onChange={goToPage}
          />
        </>
      )}
    </div>
  )
}

function IndustryChip({ icon, iconSize, label, count, active, onClick }) {
  return (
    <button
      type="button"
      className={`${styles.industryChip} ${active ? styles.industryChipActive : ''}`}
      onClick={onClick}
      aria-pressed={active}
    >
      <img src={icon} alt="" width={iconSize?.[0]} height={iconSize?.[1]} />
      {label}
      {count !== undefined && <span className={styles.chipCount}>{count.toLocaleString('vi-VN')}</span>}
    </button>
  )
}

function SegmentButton({ active, tone, onClick, children }) {
  return (
    <button
      type="button"
      role="radio"
      aria-checked={active}
      className={`${styles.segment} ${tone ? styles[`tone${tone}`] : ''} ${active ? styles.segmentActive : ''}`}
      onClick={onClick}
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
        <span className={styles.cardIndustry}>{industryLabel(question.industry)}</span>
        {level && (
          <span className={`${styles.cardLevel} ${styles[`tone${level.value}`]}`}>{level.badge}</span>
        )}
      </div>
      <h3 className={styles.cardTitle}>{question.content}</h3>
      {question.answerHint && (
        <p className={styles.cardHint}>
          <strong>Gợi ý:</strong> {question.answerHint}
        </p>
      )}
      <div className={styles.cardFooter}>
        <span className={styles.cardMeta}>
          <span>{question.position}</span>
          <span aria-hidden>•</span>
          <span>{questionTypeLabel(question.questionType).split(' (')[0]}</span>
        </span>
        <button type="button" className={styles.practiceButton} onClick={onPractice} disabled={disabled}>
          <img src={iconMicWhite} alt="" width="9.33333" height="12.6667" />
          {starting ? 'Đang tạo...' : 'Luyện tập ngay'}
        </button>
      </div>
    </article>
  )
}
