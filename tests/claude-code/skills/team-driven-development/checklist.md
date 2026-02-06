# Team-Driven Development Compliance Checklist

## Phase 0: Pre-Setup
- [ ] Branch creation offer presented (if on base branch)
- [ ] Status update offer presented (if issue tracked)

## Phase 1: Parallelization Planning
- [ ] Parallelization planner dispatched via Task() (not agent team)
- [ ] Parallelization plan saved to docs/hyperpowers/parallelization-plan.md
- [ ] Plan reviewed by lead (file overlap checks verified)
- [ ] Every task appears in exactly one batch

## Phase 2: Implementation Team
- [ ] Agent team created for implementation batch
- [ ] One teammate spawned per task in batch
- [ ] Plan approval required before teammates make changes
- [ ] File boundaries communicated to each teammate
- [ ] Delegate mode used (lead does not implement)
- [ ] All teammates completed their tasks
- [ ] Changes committed to git
- [ ] Implementation team cleaned up before next phase

## Phase 3: Review Team
- [ ] Agent team created for review
- [ ] Spec Compliance Reviewer spawned as teammate
- [ ] Code Quality Reviewer spawned as teammate
- [ ] Reviewers communicated cross-domain findings
- [ ] Review findings reported to lead
- [ ] Review team cleaned up before next phase

## Phase 4: Build/Test/Fix Team
- [ ] Agent team created for build/test/fix
- [ ] Build Runner spawned as teammate
- [ ] Test Runner spawned as teammate
- [ ] Fix Specialist spawned as teammate
- [ ] Build Runner started first
- [ ] Test Runner waited for build pass
- [ ] Fix cycles tracked (max 3)
- [ ] Build/test/fix team cleaned up

## Phase 5: Completion
- [ ] All batches processed
- [ ] verification-before-completion invoked
- [ ] Transient files cleaned up
- [ ] finishing-a-development-branch invoked
