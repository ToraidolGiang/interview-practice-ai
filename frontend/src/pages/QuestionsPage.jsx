import { useEffect, useState } from 'react'
import { useNavigate, useSearchParams } from 'react-router'
import iconBars from '../assets/figma/icon-bars.svg'
import iconBolt from '../assets/figma/icon-bolt.svg'
import iconBreadcrumbChevron from '../assets/figma/icon-breadcrumb-chevron.svg'
import iconBuilding from '../assets/figma/icon-building.svg'
import iconCloseSmall from '../assets/figma/icon-close-small.svg'
import iconFilterLines from '../assets/figma/icon-filter-lines.svg'
import iconFormat from '../assets/figma/icon-format.svg'
import iconGrid from '../assets/figma/icon-grid.svg'
import iconHome from '../assets/figma/icon-home.svg'
import iconCskh from '../assets/figma/icon-industry-cskh.svg'
import iconFinance from '../assets/figma/icon-industry-finance.svg'
import iconHr from '../assets/figma/icon-industry-hr.svg'
import iconIt from '../assets/figma/icon-industry-it.svg'
import iconMarketing from '../assets/figma/icon-industry-marketing.svg'
import iconLanguage from '../assets/figma/icon-language.svg'
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
import { formatCount } from '../utils/format'
import styles from './QuestionsPage.module.css'

const PAGE_SIZE = 6
// Thời lượng trả lời tối đa của mọi câu hỏi (UC4 B1: 10 giây - 3 phút)
const MAX_ANSWER_MINUTES = 3
const FILTER_KEYS = ['industry', 'position', 'level', 'questionType', 'keyword']
const SEARCH_SUGGESTIONS = ['Tình huống khó', 'Lãnh đạo', 'Microservices', 'Xung đột nhóm', 'Quản lý ngân sách']
// Ngân hàng câu hỏi hiện chỉ có tiếng Việt; English / Song ngữ thuộc EP7 (#134)
const LANGUAGES = [
  { value: 'vi', label: 'Tiếng Việt', available: true },
  { value: 'en', label: 'English', available: false },
  { value: 'both', label: 'Song ngữ', available: false },
]

const INDUSTRY_ICONS = {
  IT: [iconIt, 13.3333, 10.6667],
  Marketing: [iconMarketing, 13.3333, 10.6667],
  'Kinh doanh / Bán hàng': [iconTrendDark, 12.5, 7.5],
  'Kế toán / Tài chính': [iconFinance, 13.3333, 13.3333],
  'Nhân sự': [iconHr, 14.6667, 10.6667],
  'Chăm sóc khách hàng': [iconCskh, 13.3333, 12],
}

function readFilters(searchParams) {
  const filters = Object.fromEntries(FILTER_KEYS.map((k) => [k, searchParams.get(k) || '']))
  filters.page = Math.max(0, Number(searchParams.get('page')) || 0)
  return filters
}

// Số câu theo từng ngành (chip "Ngành nghề"): gọi GET /questions size=1 cho mỗi ngành và đọc totalElements.
// Không tính vị trí vì vị trí phụ thuộc ngành.
function useIndustryCounts({ level, questionType, keyword }) {
  const key = JSON.stringify({ level, questionType, keyword })
  const [counts, setCounts] = useState({ key: null, values: {} })

  useEffect(() => {
    let cancelled = false
    const base = JSON.parse(key)
    const targets = ['', ...INDUSTRIES.map((i) => i.value)]
    Promise.all(
      targets.map((industry) =>
        listQuestions({ ...base, industry, page: 0, size: 1 })
          .then((p) => [industry, p.totalElements])
          .catch(() => [industry, undefined]),
      ),
    ).then((entries) => !cancelled && setCounts({ key, values: Object.fromEntries(entries) }))
    return () => {
      cancelled = true
    }
  }, [key])

  return counts.key === key ? counts.values : {}
}

export default function QuestionsPage() {
  const navigate = useNavigate()
  const [searchParams, setSearchParams] = useSearchParams()
  const filters = readFilters(searchParams)
  const filtersKey = searchParams.toString()
  const industryCounts = useIndustryCounts(filters)

  const [keywordInput, setKeywordInput] = useState(filters.keyword)
  const [showAdvanced, setShowAdvanced] = useState(true)
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
  // Giống Figma: luôn hiện chip Ngành và Ngôn ngữ, các bộ lọc khác hiện khi đang áp dụng
  const activeChips = [
    filters.keyword && { key: 'keyword', label: `Từ khóa: ${filters.keyword}` },
    {
      key: 'industry',
      label: `Ngành: ${filters.industry ? industryLabel(filters.industry) : 'Tất cả'}`,
      removable: !!filters.industry,
    },
    filters.position && { key: 'position', label: `Vị trí: ${filters.position}` },
    filters.level && { key: 'level', label: `Độ khó: ${levelOf(filters.level)?.label}` },
    filters.questionType && {
      key: 'questionType',
      label: `Định dạng: ${questionTypeLabel(filters.questionType).split(' (')[0]}`,
    },
    { key: 'language', label: 'Ngôn ngữ: Tiếng Việt', removable: false },
  ].filter(Boolean)
  const hasClearable = FILTER_KEYS.some((k) => filters[k])

  const loading = result.key !== filtersKey
  const status = loading ? 'loading' : result.error ? 'error' : 'ready'
  const page = result.data
  const total = page?.totalElements ?? 0

  return (
    <div className={styles.page}>
      <span className={styles.glowRight} aria-hidden />
      <span className={styles.glowLeft} aria-hidden />

      <div className={styles.inner}>
        <nav className={styles.breadcrumb} aria-label="Breadcrumb">
          <img src={iconHome} alt="" width="10.6667" height="12" />
          <span>Ứng viên</span>
          <img src={iconBreadcrumbChevron} alt="" width="4.31667" height="7" />
          <span className={styles.breadcrumbCurrent}>Ngân hàng câu hỏi</span>
        </nav>

        <div className={styles.titleRow}>
          <h1 className={styles.title}>Ngân hàng câu hỏi phỏng vấn thực tế</h1>
          {/* UC3 Alt 5a: lấy ngẫu nhiên một câu theo bộ lọc */}
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
          <div className={styles.searchGroup}>
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
              <div className={styles.searchActions}>
                <span className={styles.enterHint} aria-hidden>
                  Enter ↵
                </span>
                <button type="submit" className={styles.searchButton}>
                  <img src={iconSearchWhite} alt="" width="13.5" height="13.5" />
                  Tìm kiếm
                </button>
              </div>
            </form>

            <div className={styles.suggestions}>
              <span className={styles.suggestionsLabel}>
                <img src={iconTrendDark} alt="" width="12.5" height="7.5" />
                Gợi ý tìm kiếm:
              </span>
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
          </div>

          <div className={styles.filtersBlock}>
            <div className={styles.industryRow}>
              <span className={styles.groupLabel}>
                <img src={iconBuilding} alt="" width="15" height="13.5" />
                Ngành nghề:
              </span>
              <div className={styles.industryChips}>
                <IndustryChip
                  icon={[iconGrid, 10.6667, 10.6667]}
                  label="Tất cả"
                  count={industryCounts['']}
                  active={!filters.industry}
                  onClick={() => updateFilters({ industry: '' })}
                />
                {INDUSTRIES.map((industry) => (
                  <IndustryChip
                    key={industry.value}
                    icon={INDUSTRY_ICONS[industry.value]}
                    label={industry.chipLabel}
                    count={industryCounts[industry.value]}
                    active={filters.industry === industry.value}
                    onClick={() => updateFilters({ industry: industry.value })}
                  />
                ))}
              </div>
            </div>

            {showAdvanced && (
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
                    <option value="">{filters.industry ? 'Tất cả vị trí' : 'Tất cả vị trí (chọn ngành trước)'}</option>
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

                <div className={styles.filterField}>
                  <span className={styles.fieldLabel}>
                    <img src={iconLanguage} alt="" width="14.7333" height="13.3333" />
                    Ngôn ngữ câu hỏi:
                  </span>
                  <div className={styles.segmented} role="radiogroup" aria-label="Ngôn ngữ câu hỏi">
                    {LANGUAGES.map((lang) => (
                      <SegmentButton
                        key={lang.value}
                        variant="solid"
                        active={lang.value === 'vi'}
                        disabled={!lang.available}
                        title={lang.available ? undefined : 'Sắp hỗ trợ'}
                      >
                        {lang.label}
                      </SegmentButton>
                    ))}
                  </div>
                </div>
              </div>
            )}

            <div className={styles.activeRow}>
              <div className={styles.activeChips}>
                <span className={styles.activeLabel}>
                  <img src={iconSliders} alt="" width="12" height="12" />
                  Đang áp dụng {activeChips.length} bộ lọc:
                </span>
                {activeChips.map((chip) => (
                  <span key={chip.key} className={styles.activeChip}>
                    {chip.label}
                    {chip.removable !== false && (
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
                    )}
                  </span>
                ))}
              </div>
              <div className={styles.activeActions}>
                <button type="button" className={styles.clearButton} onClick={clearAll} disabled={!hasClearable}>
                  <img src={iconReset} alt="" width="10.6667" height="12.3" />
                  Xóa tất cả bộ lọc
                </button>
                <button
                  type="button"
                  className={styles.advancedButton}
                  onClick={() => setShowAdvanced((v) => !v)}
                  aria-expanded={showAdvanced}
                >
                  <img src={iconFilterLines} alt="" width="12" height="8" />
                  Lọc nâng cao
                </button>
              </div>
            </div>
          </div>
        </section>

        <div className={styles.listHeader}>
          <div className={styles.listHeading}>
            <h2 className={styles.listTitle}>Danh sách câu hỏi tuyển dụng</h2>
            {status === 'ready' && <span className={styles.countBadge}>{formatCount(total)} CÂU</span>}
          </div>
          <label className={styles.sort}>
            Sắp xếp theo:
            {/* API chưa có tham số sắp xếp, danh sách theo thứ tự mặc định của server */}
            <select className={styles.sortSelect} defaultValue="default">
              <option value="default">Mặc định</option>
            </select>
          </label>
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
    </div>
  )
}

function IndustryChip({ icon: [src, width, height], label, count, active, onClick }) {
  return (
    <button
      type="button"
      className={`${styles.industryChip} ${active ? styles.industryChipActive : ''}`}
      onClick={onClick}
      aria-pressed={active}
    >
      <img src={src} alt="" width={width} height={height} />
      {label}
      {count !== undefined && <span className={styles.chipCount}>{formatCount(count)}</span>}
    </button>
  )
}

function SegmentButton({ active, tone, variant = 'soft', disabled, title, onClick, children }) {
  const activeClass = active ? (variant === 'solid' ? styles.segmentSolid : styles.segmentSoft) : ''
  return (
    <button
      type="button"
      role="radio"
      aria-checked={active}
      disabled={disabled}
      title={title}
      className={`${styles.segment} ${tone ? styles[`tone${tone}`] : ''} ${activeClass}`}
      onClick={onClick}
    >
      {children}
    </button>
  )
}

function QuestionCard({ question, starting, disabled, onPractice }) {
  const level = levelOf(question.level)
  const hintLabel = question.questionType === 'BEHAVIORAL' ? 'STAR:' : 'Gợi ý:'
  return (
    <article className={styles.card}>
      <div className={styles.cardBody}>
        <div className={styles.cardTop}>
          <span className={styles.cardIndustry}>{industryLabel(question.industry)}</span>
          {level && <span className={styles[`tone${level.value}`]}>{level.badge}</span>}
        </div>
        <h3 className={styles.cardTitle}>{question.content}</h3>
        {question.answerHint && (
          <p className={styles.cardHint}>
            <strong>{hintLabel}</strong> {question.answerHint}
          </p>
        )}
      </div>
      <div className={styles.cardFooter}>
        <span className={styles.cardMeta}>
          <span className={styles.cardMetaStrong} title={question.position}>
            {question.position}
          </span>
          <span className={styles.bullet} aria-hidden>
            •
          </span>
          <span className={styles.cardMetaItem}>{MAX_ANSWER_MINUTES} phút</span>
        </span>
        <button type="button" className={styles.practiceButton} onClick={onPractice} disabled={disabled}>
          <img src={iconMicWhite} alt="" width="9.33333" height="12.6667" />
          {starting ? 'Đang tạo...' : 'Luyện tập ngay'}
        </button>
      </div>
    </article>
  )
}
