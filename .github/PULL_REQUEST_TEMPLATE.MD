## Description

Please provide a brief description of the changes in this pull request.

## Related Issues

List any related issues or tickets that this pull request addresses or resolves. For example:

- Resolves #123 (issue number)
- Relates to #456 (issue number)

## Type of Change

- [ ] Bug fix (non-breaking change fixing an issue)
- [ ] New feature (non-breaking change adding functionality)
- [ ] Breaking change (fix or feature causing existing functionality to change)
- [ ] Security fix (addresses a vulnerability)
- [ ] Documentation update
- [ ] Dependency update
- [ ] Configuration change
- [ ] Chore/maintenance (refactoring, tooling, etc.)

## Changes

Describe the changes in detail:

1. Change 1
2. Change 2
3. ...

## Testing

### Manual Testing Performed
Describe what you manually tested (if applicable):

**Testing steps:**
1.
2.
3.

**Tested environments:**
- [ ] Local development
- [ ] Other: _____________

**N/A** - No manual testing needed (e.g., documentation change, automated tests sufficient)

---

## 🤖 Automated Verification (CI/CD)

The following checks are **automatically verified** by CI/CD - you don't need to check these manually:

✅ **Automated Tests**
- Unit tests (Java Maven + Node.js Jest)
- Integration tests
- Code quality (ESLint, Prettier)

✅ **Security Scanning**
- Grype vulnerability scanning (fails on medium+ severity)
- Dependency vulnerability checks
- SARIF security report uploaded to GitHub Security tab

✅ **SBOM Generation**
- SPDX and CycloneDX SBOMs generated
- Available in PR artifacts for review

**Status**: Check CI results above ☝️ - all checks must pass before merge

---

## 👤 Manual Review Required

**⚠️ IMPORTANT: This PR will be automatically released to production after merge**

### Author Self-Review
Before requesting review, confirm:

- [ ] **Code quality**: I have reviewed my own code for logic errors, edge cases, and code smells
- [ ] **Security**: I have considered security implications of these changes (authentication, authorization, input validation, data exposure)
- [ ] **Breaking changes**: I have identified and documented any breaking changes
- [ ] **Documentation**: I have updated relevant documentation (README, API docs, code comments)

### Reviewer Checklist

**Reviewers must verify:**

- [ ] **Business logic**: Changes implement the intended functionality correctly
- [ ] **Security**: No obvious security issues (focus on: data exposure, access control, input handling)
- [ ] **Breaking changes**: Any breaking changes are justified and documented
- [ ] **Code quality**: Code is readable, maintainable, and follows project conventions
- [ ] **Test coverage**: Changes are adequately tested (new tests added where needed)

**For security-sensitive changes** (authentication, authorization, data access, external integrations):
- [ ] **Second reviewer**: Security-sensitive change reviewed by second maintainer

---

## Production Deployment Impact

### Breaking Changes
- [ ] **No breaking changes**
- [ ] **Breaking changes documented below**

**Breaking change details** (if applicable):
- What breaks:
- Migration steps:
- Backwards compatibility:

### Rollback Plan
- [ ] **Low risk** - Standard rollback (revert commit)
- [ ] **High risk** - Rollback plan documented below

**Rollback details** (if high-risk):
- Rollback approach:
- Data considerations:
- Configuration changes:

---

## Additional Context

### Review Focus
What should reviewers pay special attention to?

1.
2.
3.

### Screenshots/Videos (if applicable)
<!-- Add screenshots or videos to help explain your changes -->

### Additional Notes
<!-- Any other context helpful for review or production deployment -->
