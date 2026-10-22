// Trang giữ chỗ cho các màn hình chưa làm (đã có thiết kế trên Figma)
export default function Placeholder({ title, note }) {
  return (
    <section style={{ padding: '48px 0', textAlign: 'center' }}>
      <h1 style={{ fontFamily: 'var(--font-heading)', fontSize: 24, color: 'var(--color-text-strong)' }}>
        {title}
      </h1>
      <p style={{ marginTop: 8, color: 'var(--color-text-subtle)' }}>{note}</p>
    </section>
  )
}
