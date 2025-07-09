export function getToastIcon(type) {
  switch (type) {
    case 'success': return CheckCircleIcon
    case 'error': return AlertCircleIcon
    case 'info': return InfoIcon
    default: return InfoIcon
  }
}
export function getToastColor(type) {
  switch (type) {
    case 'success': return 'bg-green-100 text-green-800'
    case 'error': return 'bg-red-100 text-red-800'
    case 'info': return 'bg-blue-100 text-blue-800'
    default: return 'bg-gray-100 text-gray-800'
  }
}
export function addToast(type, title, message, toasts) {
  // Ensure message is string
  if (typeof message !== 'string') {
    try {
      message = JSON.stringify(message)
    } catch {
      message = String(message)
    }
  }
  // Skip adding toast if message is empty or still an object-like string
  if (!message || message === '[object Object]') {
    return
  }
  toasts.push({
    id: Date.now(),
    type,
    title,
    message,
  })
}
export function removeToast(id, toasts) {
  const index = toasts.findIndex(toast => toast.id === id)
  if (index !== -1) toasts.splice(index, 1)
}
