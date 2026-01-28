# APR Experiment Ideas - Raw List (30)

> **Generated:** 2026-01-27
> **Purpose:** Brainstorm before filtering

---

## Category A: Basic Validation (Does APR work at all?)

1. **E01-basic-setup**: Run `apr setup` with minimal test files, verify workflow creation works
2. **E02-dry-run**: Create workflow, run `apr run 1 --dry-run` to see what gets sent
3. **E03-oracle-connection**: Verify Oracle can connect to ChatGPT via browser mode
4. **E04-simple-spec**: Run 1 round on a trivial 10-line spec, verify we get output
5. **E05-robot-mode**: Test all `apr robot` commands work correctly

## Category B: Spec Refinement (APR's Native Use Case)

6. **E06-real-spec**: Run 5 rounds on research_tool's SPECIFICATION.md
7. **E07-convergence-tracking**: Run until convergence detected, verify metrics
8. **E08-include-impl**: Test `--include-impl` flag with real implementation
9. **E09-round-diff**: Verify `apr diff` shows meaningful differences
10. **E10-integrate-output**: Test `apr integrate` generates usable Claude prompt

## Category C: Research Query Adaptation (Novel Use Case)

11. **E11-research-template**: Create a research-oriented prompt template
12. **E12-single-research**: Run 1 round with a research question, analyze output
13. **E13-multi-round-research**: Run 3 rounds on same research question, check if useful
14. **E14-research-convergence**: Does convergence algorithm detect "answer completeness"?
15. **E15-research-vs-spec**: Compare same question as spec vs research template

## Category D: Integration with research_tool

16. **E16-oracle-in-rt**: Call Oracle from research_tool TypeScript code
17. **E17-apr-robot-in-rt**: Call `apr robot run` from research_tool
18. **E18-triangulation-input**: Use APR output as input to triangulation
19. **E19-apr-as-stage**: Add APR as a pipeline stage in research_tool
20. **E20-shared-state**: Experiment with sharing session data between tools

## Category E: Prompt Engineering

21. **E21-minimal-prompt**: What's the minimum viable prompt template?
22. **E22-structured-output**: Prompt for JSON/structured output instead of prose
23. **E23-critique-prompt**: Prompt that asks for critique rather than revision
24. **E24-comparison-prompt**: Prompt that compares two approaches
25. **E25-meta-prompt**: Prompt that improves its own prompt

## Category F: Workflow Variations

26. **E26-no-readme**: What happens without README context?
27. **E27-code-as-spec**: Use actual code file instead of markdown spec
28. **E28-multi-file-spec**: Spec split across multiple files
29. **E29-external-context**: Pull context from external sources (web, API)
30. **E30-headless-oracle**: Test Oracle's remote serve mode for VPS

---

## Next Step

Evaluate each against criteria:
1. What you hope to learn
2. Why valuable
3. If success: what?
4. If fail: what you will do?
