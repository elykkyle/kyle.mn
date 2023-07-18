describe('Visit Counter', () => {
  it('gets visitor count', () => {
    cy.visit('/resume.html')
    cy.get('#visitor-count').should(
      'not.contain', 'Loading...'
    )


  })
})