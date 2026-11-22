import { downloadBlob, request } from './client'

// from/to (yyyy-MM-dd) bỏ trống thì không gửi query
function rangeQuery({ from, to } = {}) {
  const params = {}
  if (from) params.from = from
  if (to) params.to = to
  return params
}

export function getAnalyticsOverview(range) {
  const query = new URLSearchParams(rangeQuery(range)).toString()
  return request(`/admin/analytics/overview${query ? `?${query}` : ''}`)
}

// Chỉ hỗ trợ CSV (xlsx backend trả 400)
export function exportAnalyticsCsv(range) {
  return downloadBlob('/admin/analytics/export', {
    params: { format: 'csv', ...rangeQuery(range) },
    filename: 'analytics.csv',
  })
}
