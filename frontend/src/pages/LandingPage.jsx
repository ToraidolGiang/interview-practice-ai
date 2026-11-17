import { useState } from 'react'
import { Link } from 'react-router'
import ctaArt from '../assets/illustrations/cta.png'
import devicesArt from '../assets/illustrations/landing-devices.png'
import faqArt from '../assets/illustrations/faq.png'
import { useAuth } from '../auth/AuthContext'
import Icon from '../components/Icon'
import Logo from '../components/Logo'
import { formatVnd, FREE_MONTHLY_SESSIONS, PRO_PRICES } from '../constants/plans'
import styles from './LandingPage.module.css'

const STEPS = [
  {
    no: '01',
    tag: 'Lựa chọn',
    title: 'Chọn vị trí mục tiêu & ngành',
    desc: 'Lọc theo ngành, vị trí và độ khó. Mỗi câu hỏi có gợi ý cách trả lời phù hợp với loại câu hỏi.',
  },
  {
    no: '02',
    tag: 'Mô phỏng',
    title: 'Trả lời phỏng vấn qua micro',
    desc: 'Ghi âm trực tiếp trên trình duyệt từ 10 giây đến 3 phút, nghe lại trước khi nộp. Trả lời bằng tiếng Việt.',
  },
  {
    no: '03',
    tag: 'Đánh giá',
    title: 'Nhận bảng điểm AI & Gợi ý',
    desc: 'Điểm từng tiêu chí kèm trích dẫn câu trả lời, tốc độ nói, từ đệm và câu trả lời mẫu để luyện lại.',
  },
]

const COMPARISON = [
  ['Chấm điểm có căn cứ', 'Mỗi điểm số kèm lý do và trích dẫn', 'Cảm tính, thiếu tiêu chuẩn', 'Rubric rõ ràng theo loại câu hỏi'],
  ['Phân tích âm học (WPM, từ đệm)', 'Đo tốc độ và chỉ ra điểm vấp', 'Không thể đo lường chính xác', 'Đo WPM & từ đệm tự động'],
  ['Tính sẵn sàng phục vụ', 'Luyện tập bất cứ khi nào bạn rảnh rỗi', 'Phụ thuộc vào lịch người khác', 'Sẵn sàng 24/7/365'],
  ['Tâm lý & sự ngượng ngùng', 'Không sợ phán xét, thoải mái sửa sai', 'Dễ ngượng ngùng, thiếu tự nhiên', 'Luyện riêng tư, không ai phán xét'],
]

const BENEFITS = [
  ['Điểm từng tiêu chí, có trích dẫn', 'Mỗi điểm kèm lý do và câu nói nguyên văn của bạn.'],
  ['Tốc độ nói và từ đệm', 'Biết mình nói nhanh hay chậm, dùng “ừm”, “ờ” bao nhiêu lần.'],
  ['Câu trả lời mẫu', 'Gợi ý cách kể lại câu chuyện của bạn chặt chẽ hơn.'],
  ['Nghe nhận xét bằng giọng nói', 'AI đọc lời khuyên bằng tiếng Việt để bạn nghe lại.'],
]

const PREVIEW_CRITERIA = [
  {
    name: 'Độ liên quan',
    weight: 20,
    score: 5,
    desc: 'Trả lời đúng trọng tâm: kể sự cố thật, cách xử lý và bài học.',
    quote: 'dịch vụ thanh toán bị sập hoàn toàn',
    points: '20.0 / 20',
  },
  {
    name: 'Cấu trúc (STAR)',
    weight: 30,
    score: 4,
    desc: 'Đủ Tình huống, Nhiệm vụ, Hành động; phần Kết quả còn ngắn.',
    star: true,
    quote: 'em là người trực on-call nên chịu trách nhiệm điều phối xử lý',
    points: '22.5 / 30',
  },
  {
    name: 'Độ cụ thể',
    weight: 40,
    score: 3,
    desc: 'Có chi tiết kỹ thuật nhưng thiếu số liệu đo được.',
    quote: 'Sau khoảng hai mươi phút thì hệ thống chạy lại bình thường',
    points: '20.0 / 40',
  },
]

const FREE_FEATURES = [
  `${FREE_MONTHLY_SESSIONS} lượt phỏng vấn AI mỗi tháng`,
  'Ngân hàng câu hỏi cơ bản',
  'Chấm điểm theo rubric',
  'Lưu lịch sử 6 tháng',
]
const PRO_FEATURES = [
  'Phỏng vấn AI không giới hạn',
  'Toàn bộ 1,240+ câu hỏi theo 6 ngành',
  'Phân tích âm học: WPM & từ đệm',
  'Phản hồi giọng nói & câu trả lời mẫu',
  'Theo dõi tiến bộ qua từng phiên',
]
const ENTERPRISE_FEATURES = [
  'Mọi tính năng của Pro',
  'Bảng quản lý học viên / ứng viên',
  'Bộ câu hỏi tuỳ chỉnh theo JD',
  'Báo cáo tiến bộ theo nhóm',
  'Hỗ trợ triển khai',
]

const FAQ = [
  [
    'InterviewAI có thực sự miễn phí không?',
    `Có! Mỗi tháng bạn có ${FREE_MONTHLY_SESSIONS} lượt phỏng vấn miễn phí và dùng được ngân hàng câu hỏi cơ bản. Gói Pro mở khoá luyện tập không giới hạn, phân tích giọng nói đầy đủ và câu trả lời mẫu.`,
  ],
  [
    'AI chấm điểm và phân tích câu trả lời như thế nào?',
    'Bản ghi được chuyển thành văn bản, hệ thống tự tính tốc độ nói và từ đệm, sau đó AI chấm từng tiêu chí của rubric theo loại câu hỏi (thang 1–5) kèm trích dẫn nguyên văn làm căn cứ. Tổng điểm do hệ thống tính theo trọng số, không do AI tự đặt.',
  ],
  [
    'Điểm số được chấm dựa trên những tiêu chí nào?',
    'Mỗi loại câu hỏi có bộ tiêu chí riêng: Độ liên quan, Cấu trúc, Độ cụ thể, Đúng chuyên môn (câu kỹ thuật) và Trình bày (tốc độ nói, từ đệm). Trọng số được công bố ngay trong phòng luyện tập.',
  ],
  [
    'Dữ liệu âm thanh và câu trả lời của tôi có được bảo mật không?',
    'Chỉ bạn xem được lịch sử của mình. Bản ghi âm được tự động xoá sau 6 tháng; transcript, điểm số và nhận xét được giữ lại để bạn theo dõi tiến bộ.',
  ],
]

export default function LandingPage() {
  const { isAuthenticated } = useAuth()
  const [yearly, setYearly] = useState(false)
  const [openFaq, setOpenFaq] = useState(0)
  const startTo = isAuthenticated ? '/dashboard' : '/register'
  const pro = yearly ? PRO_PRICES.yearly : PRO_PRICES.monthly

  return (
    <div className={styles.page}>
      <header className={styles.nav}>
        <div className={styles.navInner}>
          <Logo size={36} />
          <nav className={styles.navLinks} aria-label="Điều hướng trang chủ">
            <a href="#top" className={styles.navActive}>
              Trang chủ
            </a>
            <Link to="/questions">Ngân hàng câu hỏi</Link>
            <a href="#steps">Luyện tập phỏng vấn</a>
            <a href="#pricing">Bảng giá</a>
          </nav>
          <div className={styles.navActions}>
            <button type="button" className={styles.lang} title="Tiếng Việt">
              <Icon name="globe" size={14} strokeWidth={1.8} className={styles.globe} />
              VI
              <span aria-hidden>▾</span>
            </button>
            {isAuthenticated ? (
              <Link to="/dashboard" className={`btn btn-primary ${styles.navCta}`}>
                Vào bảng điều khiển
              </Link>
            ) : (
              <>
                <Link to="/login" className={styles.login}>
                  Đăng nhập
                </Link>
                <Link to="/register" className={`btn btn-primary ${styles.navCta}`}>
                  Đăng ký miễn phí
                </Link>
              </>
            )}
          </div>
        </div>
      </header>

      <section className={styles.hero} id="top">
        <span className={styles.heroBadge}>LUYỆN PHỎNG VẤN BẰNG GIỌNG NÓI · 100% TIẾNG VIỆT</span>
        <h1 className={styles.heroTitle}>
          Chinh phục mọi buổi phỏng vấn cùng <span>InterviewAI</span>
        </h1>
        <p className={styles.heroText}>
          Luyện tập mô phỏng thực chiến, nhận chấm điểm theo rubric minh bạch cho từng loại câu hỏi (hành vi, tình huống,
          kỹ thuật, giới thiệu) kèm phân tích tốc độ nói và từ đệm, tự tin bước vào buổi phỏng vấn thật.
        </p>
        <div className={styles.heroButtons}>
          <Link to={startTo} className={styles.heroPrimary}>
            Thử phỏng vấn AI ngay (Miễn phí)
            <Icon name="arrowRight" size={16} strokeWidth={2.2} />
          </Link>
          <Link to="/questions" className={styles.heroGhost}>
            Xem ngân hàng câu hỏi
          </Link>
        </div>
        <dl className={styles.stats}>
          <div>
            <dt>1,240+</dt>
            <dd>câu hỏi luyện tập</dd>
          </div>
          <div>
            <dt>≈12 giây</dt>
            <dd>có kết quả chấm điểm</dd>
          </div>
          <div>
            <dt>4 loại</dt>
            <dd>hành vi, tình huống, kỹ thuật, giới thiệu</dd>
          </div>
        </dl>
        <img className={styles.devices} src={devicesArt} alt="Giao diện phòng luyện tập và kết quả chấm điểm của InterviewAI" width="1280" height="518" />
      </section>

      <section className={styles.section} id="steps">
        <SectionHeading
          eyebrow="Đơn giản & hiệu quả"
          title="Quy trình 3 bước chuẩn bị phỏng vấn"
          sub="Chỉ mất 5 phút mỗi ngày để rèn luyện tư duy phản biện và phản xạ giao tiếp chuyên nghiệp trước giờ G."
        />
        <div className={styles.steps}>
          {STEPS.map((s) => (
            <article key={s.no} className={styles.step}>
              <div className={styles.stepTop}>
                <span className={styles.stepNo}>{s.no}</span>
                <span className={styles.stepTag}>{s.tag}</span>
              </div>
              <h3>{s.title}</h3>
              <p>{s.desc}</p>
            </article>
          ))}
        </div>
      </section>

      <section className={styles.section}>
        <SectionHeading
          eyebrow="Lợi thế vượt trội"
          title="Tại sao nên chọn InterviewAI?"
          sub="So sánh giữa phương pháp truyền thống và công nghệ huấn luyện phỏng vấn chuẩn hóa bởi AI thông minh."
        />
        <div className={styles.compare}>
          <div className={styles.compareHead}>
            <span>Tiêu chí đánh giá</span>
            <span>Tự luyện / Bạn bè</span>
            <span className={styles.compareBrand}>
              <Icon name="starCircle" size={18} />
              InterviewAI Platform
            </span>
          </div>
          {COMPARISON.map(([title, sub, self, ai]) => (
            <div key={title} className={styles.compareRow}>
              <span>
                <strong>{title}</strong>
                <small>{sub}</small>
              </span>
              <span className={styles.compareSelf}>{self}</span>
              <span className={styles.compareAi}>
                <Icon name="checkCircle" size={16} />
                {ai}
              </span>
            </div>
          ))}
        </div>
      </section>

      <section className={`${styles.section} ${styles.white}`}>
        <div className={styles.results}>
          <div className={styles.resultsText}>
            <p className={styles.eyebrow}>Kết quả bạn nhận được</p>
            <h2>Biết chính xác câu trả lời cần sửa ở đâu</h2>
            <p className={styles.lead}>
              Mỗi câu trả lời được chấm theo rubric của đúng loại câu hỏi. Không chỉ một con số, bạn thấy rõ lý do của
              từng điểm.
            </p>
            <ul className={styles.benefits}>
              {BENEFITS.map(([title, desc]) => (
                <li key={title}>
                  <span className={styles.benefitIcon}>
                    <Icon name="check" size={12} strokeWidth={3} />
                  </span>
                  <span>
                    <strong>{title}</strong>
                    <small>{desc}</small>
                  </span>
                </li>
              ))}
            </ul>
            <Link to={startTo} className="btn btn-primary">
              Thử miễn phí
            </Link>
          </div>
          <ResultPreview />
        </div>
      </section>

      <section className={styles.section} id="pricing">
        <div className={styles.heading}>
          <span className={styles.pricingBadge}>BẢNG GIÁ MINH BẠCH</span>
          <h2>Bắt đầu miễn phí, nâng cấp khi cần</h2>
          <p>
            Bắt đầu miễn phí với {FREE_MONTHLY_SESSIONS} lượt phỏng vấn AI. Nâng cấp khi bạn cần luyện tập không giới hạn
            và phân tích chuyên sâu.
          </p>
        </div>
        <div className={styles.cycle} role="radiogroup" aria-label="Chu kỳ thanh toán">
          <button type="button" role="radio" aria-checked={!yearly} className={!yearly ? styles.cycleOn : undefined} onClick={() => setYearly(false)}>
            Theo tháng
          </button>
          <button type="button" role="radio" aria-checked={yearly} className={yearly ? styles.cycleOn : undefined} onClick={() => setYearly(true)}>
            Theo năm <span className="pill pill-green">-{PRO_PRICES.yearly.discount}%</span>
          </button>
        </div>
        <div className={styles.plans}>
          <article className={styles.plan}>
            <h3>Miễn phí</h3>
            <p className={styles.planDesc}>Làm quen với phỏng vấn AI và cách chấm điểm.</p>
            <p className={styles.price}>
              0đ <small>/ mãi mãi</small>
            </p>
            <Link to={startTo} className={`btn btn-soft btn-block ${styles.planButton}`}>
              Bắt đầu miễn phí
            </Link>
            <PlanFeatures items={FREE_FEATURES} />
          </article>
          <article className={`${styles.plan} ${styles.planPro}`}>
            <div className={styles.planHead}>
              <h3>Pro</h3>
              <span className={styles.popular}>PHỔ BIẾN NHẤT</span>
            </div>
            <p className={styles.planDesc}>Cho ứng viên đang chuẩn bị phỏng vấn thật.</p>
            <p className={styles.price}>
              {formatVnd(pro.perMonth)} <small>/ tháng</small>
            </p>
            {yearly && <p className={styles.billedYearly}>Thanh toán {formatVnd(pro.total)} mỗi năm</p>}
            <Link to={isAuthenticated ? '/upgrade' : '/register'} className={`btn btn-block ${styles.planButton} ${styles.proButton}`}>
              Nâng cấp lên Pro
            </Link>
            <PlanFeatures items={PRO_FEATURES} filled />
          </article>
          <article className={styles.plan}>
            <h3>Doanh nghiệp &amp; Trường học</h3>
            <p className={styles.planDesc}>Đào tạo và đánh giá ứng viên theo nhóm.</p>
            <p className={`${styles.price} ${styles.contact}`}>Liên hệ</p>
            <a href="mailto:contact@interviewai.vn" className={`btn btn-block ${styles.planButton} ${styles.darkButton}`}>
              Liên hệ tư vấn
            </a>
            <PlanFeatures items={ENTERPRISE_FEATURES} />
          </article>
        </div>
        <ul className={styles.guarantees}>
          <li>
            <Icon name="shieldCheck" size={15} /> Thanh toán qua MoMo, VNPay, thẻ quốc tế
          </li>
          <li>
            <Icon name="shieldCheck" size={15} /> Huỷ gói bất cứ lúc nào
          </li>
          <li>
            <Icon name="shieldCheck" size={15} /> Hoàn tiền trong 7 ngày nếu không hài lòng
          </li>
        </ul>
      </section>

      <section className={styles.section} id="faq">
        <SectionHeading
          eyebrow="Giải đáp thắc mắc"
          title="Câu hỏi thường gặp"
          sub="Mọi điều bạn cần biết trước khi bước vào hành trình luyện tập cùng InterviewAI."
        />
        <div className={styles.faq}>
          <img src={faqArt} alt="" width="424" height="354" className={styles.faqArt} />
          <div className={styles.faqList}>
            {FAQ.map(([q, a], i) => {
              const open = openFaq === i
              return (
                <div key={q} className={`${styles.faqItem} ${open ? styles.faqOpen : ''}`}>
                  <button type="button" onClick={() => setOpenFaq(open ? -1 : i)} aria-expanded={open}>
                    {q}
                    <Icon name={open ? 'chevronUp' : 'chevronDown'} size={18} />
                  </button>
                  {open && <p>{a}</p>}
                </div>
              )
            })}
          </div>
        </div>
      </section>

      <section className={styles.ctaWrap}>
        <div className={styles.cta}>
          <img src={ctaArt} alt="" width="384" height="320" className={styles.ctaArt} />
          <div className={styles.ctaText}>
            <span className={styles.ctaBadge}>
              <Icon name="rocket" size={13} /> BẮT ĐẦU MIỄN PHÍ
            </span>
            <h2>Sẵn sàng chinh phục nhà tuyển dụng ngay hôm nay?</h2>
            <p>
              Đừng để sự thiếu chuẩn bị cản trở cơ hội nghề nghiệp của bạn. Thử ngay buổi phỏng vấn thử đầu tiên và nhận
              phản hồi chi tiết từ InterviewAI trong vòng 3 phút.
            </p>
            <ul className={styles.ctaChecks}>
              <li>
                <Icon name="checkCircle" size={15} /> Không cần thẻ tín dụng
              </li>
              <li>
                <Icon name="checkCircle" size={15} /> Bảng điểm STAR tức thì
              </li>
              <li>
                <Icon name="checkCircle" size={15} /> 1,240+ câu hỏi
              </li>
            </ul>
            <div className={styles.ctaButtons}>
              <Link to={startTo} className={styles.ctaPrimary}>
                Đăng ký — Hoàn toàn Miễn phí
                <Icon name="arrowRight" size={16} strokeWidth={2.2} />
              </Link>
              <Link to={isAuthenticated ? '/dashboard' : '/login'} className={styles.ctaGhost}>
                <Icon name="userCircle" size={17} />
                Tiếp tục với Google
              </Link>
            </div>
          </div>
        </div>
      </section>

      <footer className={styles.footer}>
        <div className={styles.footerGrid}>
          <div className={styles.footerAbout}>
            <Logo size={36} />
            <p>
              Nền tảng luyện phỏng vấn thử nghiệm thông minh ứng dụng AI hàng đầu tại Việt Nam. Đánh giá phát âm, phản xạ
              STAR và kiến thức chuyên môn chuẩn hóa theo từng vị trí tuyển dụng.
            </p>
            <div className={styles.footerBadges}>
              <span className="pill pill-green">Hệ thống AI v2.4 Active</span>
              <span className={styles.isoBadge}>Bảo mật ISO/IEC 27001</span>
            </div>
          </div>
          <FooterCol title="Sản phẩm" links={[['Ngân hàng câu hỏi', '/questions'], ['Luyện phỏng vấn', '#steps'], ['Bảng giá', '#pricing']]} />
          <FooterCol title="Hỗ trợ" links={[['Câu hỏi thường gặp', '#faq'], ['Hướng dẫn trả lời theo loại câu hỏi', '#steps'], ['Liên hệ', 'mailto:contact@interviewai.vn']]} />
          <FooterCol title="Pháp lý" links={[['Điều khoản sử dụng', '#'], ['Chính sách bảo mật', '#'], ['Chính sách dữ liệu ghi âm', '#']]} />
        </div>
        <div className={styles.footerBottom}>
          <span>© 2026 InterviewAI · Đồ án nền tảng luyện phỏng vấn xin việc tích hợp AI.</span>
          <span className={styles.footerMeta}>
            <span>
              <Icon name="shieldCheck" size={14} /> Tuân thủ Nghị định 13/2023/NĐ-CP
            </span>
            <i aria-hidden>•</i>
            <span>Hà Nội &amp; TP. Hồ Chí Minh</span>
          </span>
        </div>
      </footer>
    </div>
  )
}

function SectionHeading({ eyebrow, title, sub }) {
  return (
    <div className={styles.heading}>
      <p className={styles.eyebrow}>{eyebrow}</p>
      <h2>{title}</h2>
      <p>{sub}</p>
    </div>
  )
}

function PlanFeatures({ items, filled }) {
  return (
    <ul className={`${styles.features} ${filled ? styles.featuresFilled : ''}`}>
      {items.map((f) => (
        <li key={f}>
          <span className={styles.featureIcon}>
            <Icon name="check" size={filled ? 11 : 13} strokeWidth={3} />
          </span>
          {f}
        </li>
      ))}
    </ul>
  )
}

function FooterCol({ title, links }) {
  return (
    <div className={styles.footerCol}>
      <h4>{title}</h4>
      <ul>
        {links.map(([label, href]) => (
          <li key={label}>
            {href.startsWith('/') ? <Link to={href}>{label}</Link> : <a href={href}>{label}</a>}
          </li>
        ))}
      </ul>
    </div>
  )
}

// Thẻ kết quả mẫu minh hoạ (dữ liệu ví dụ trong thiết kế, không phải kết quả của người dùng)
function ResultPreview() {
  return (
    <div className={styles.preview} aria-label="Ví dụ kết quả chấm điểm">
      <div className={styles.previewHead}>
        <span className={styles.previewPills}>
          <span className="pill pill-indigo">IT · Backend Developer</span>
          <span className="pill pill-gray">Hành vi</span>
        </span>
        <span className={styles.previewScore}>
          71.3 <small>/ 100</small>
        </span>
      </div>
      {PREVIEW_CRITERIA.map((c) => (
        <div key={c.name} className={styles.previewRow}>
          <div className={styles.previewRowHead}>
            <strong>
              {c.name} <span className="pill pill-gray">{c.weight}%</span>
            </strong>
            <span className={styles.previewBar}>
              {[1, 2, 3, 4, 5].map((i) => (
                <i key={i} className={i <= c.score ? (c.score >= 4 ? styles.segGreen : styles.segAmber) : undefined} />
              ))}
              <b>{c.score}/5</b>
            </span>
          </div>
          <p>{c.desc}</p>
          {c.star && (
            <div className={styles.starChips}>
              <span className="pill pill-green">✓ Tình huống</span>
              <span className="pill pill-green">✓ Nhiệm vụ</span>
              <span className="pill pill-green">✓ Hành động</span>
              <span className="pill pill-amber">
                <Icon name="halfCircle" size={11} /> Kết quả
              </span>
            </div>
          )}
          <blockquote>“{c.quote}”</blockquote>
          <small>Đóng góp {c.points} điểm</small>
        </div>
      ))}
      <p className={styles.previewFoot}>
        <strong>Trình bày 4.5 / 5</strong> 140 từ/phút · 6 từ đệm
      </p>
    </div>
  )
}
