url = 'PLACEHOLDER'

const visitorCount = document.getElementById('visitor-count')
const countRequest = new Request(url)

fetch(countRequest)
  .then((res) => {
    if (!res.ok) {
      throw new Error(`HTTP error, status = ${res.status}`);
    }
    return res.json()
  })
  .then((data) => {
    console.log(data.viewCount.N)
    visitorCount.innerText = data.viewCount.N
  })
  .catch((error) => {
    console.error(error)
  })