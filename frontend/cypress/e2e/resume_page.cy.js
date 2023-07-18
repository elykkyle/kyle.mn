describe('Resume page', () => {
  it('loads', () => {
    cy.visit('/resume.html')
    cy.contains('Work Experience')
  })
})