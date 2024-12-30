const toggleTheme = () => {
  console.log('toggleTheme')
  const body = document.querySelector('body')
  body.className = body.classList.contains('dark-theme') ? 'light-theme' : 'dark-theme'
}