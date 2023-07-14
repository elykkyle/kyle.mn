describe('Visit Counter', () => {
  it('gets visitor count', () => {
    cy.visit('http://127.0.0.1:5500/src/resume.html')
    cy.get('#visitor-count').should(
      'not.contain', 'Loading...'
    )


  })
})