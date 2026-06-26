const backendOrigin = 'http://localhost:8080'

export const assetUrl = (path, fallback = '') => {
  if (!path) return fallback
  if (path.startsWith('http://') || path.startsWith('https://')) return path
  return `${backendOrigin}${path}`
}
