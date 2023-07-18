describe('Home page loads', () => {
  it('loads', () => {
    cy.visit('/index.html')
    cy.contains("Hi, my name is")
    cy.contains('Kyle Williams')
  })
})