describe('Home page loads', () => {
  it('loads', () => {
    cy.visit('http://127.0.0.1:5500/src/index.html')
    cy.contains("Hi, my name is")
    cy.contains('Kyle Williams')
  })
})