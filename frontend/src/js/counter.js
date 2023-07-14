const visitorCount = document.getElementById('visitor-count')
const countRequest = new Request('https://0oma0z9793.execute-api.us-east-2.amazonaws.com/default/incrementViewCount')

fetch(countRequest)
  .then((res) => {
    if (!res.ok) {
      throw new Error(`HTTP error, status = ${res.status}`);
    }
    // console.log(res.json())
    return res.json()
  })
  .then((data) => {
    console.log(data.viewCount.N)
    visitorCount.innerText = data.viewCount.N
  })
  .catch((error) => {
    console.error(error)
  })

// console.log(viewCount.N)