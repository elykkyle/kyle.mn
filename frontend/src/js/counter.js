url = 'PLACEHOLDER'

const visitorCount = document.getElementById('visitor-count')
const countRequest = new Request(`${url}/visitorCount`)

fetch(countRequest)
  .then((res) => {
    if (!res.ok) {
      throw new Error(`HTTP error, status = ${res.status}`);
    }
    return res.json()
  })
  .then((data) => {
    visitorCount.innerText = data
  })
  .catch((error) => {
    console.error(error)
  })