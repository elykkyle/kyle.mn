describe('Resume page', () => {
  it('loads', () => {
    cy.visit('http://127.0.0.1:5500/src/resume.html')
    cy.contains('Work Experience')
  })
})