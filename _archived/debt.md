---
layout:		default
title:		About Technical Debt
date:		2019-04-06
categories: articles
---

# About Technical Debt

I was recently surveyed about technical debt by
[Mr. Reem Alfayez](https://www.researchgate.net/scientific-contributions/2120714693_Reem_Alfayez),
and he posed this very well-formulated question:

*What is your method in prioritizing technical debt items to repay
(How do you decide which technical debt item to repay first)?*

This led me to spend some time examining my mental model of technical debt,
and as very good questions often do, revealed several unspoken assumptions
on which I was operating.

I would love to write more on this, isolating examples and precisely
quantifying development times involved, lines of code and git commit diffs.

For now however I wanted to log this data somewhere for my own future reference:

## How to Prioritize Technical Debt Repayment

Priority is based on resource cost, where repayment (refactoring) cost is cheapest
because a bugfix or new feature request demands touching the same area of code.

3 examples to illustrate data points along this continuum:

1. Need to add feature x and it's most time-effective
    to just rewrite the entire file.

    Quote management/clients for rewriting the file and write off
    technical debt for free.

    This is an unqualified win. Highest priority.


1. Bug report points to `struct x` and related functions,
    but the cause is not immediately obvious.

    Here the cost of refactoring known technical debt is inversely proportional
    to the work/difficulty required to instrument/trace the bug,
    which can be quite high for [heisenbugs](http://www.jargon.net/jargonfile/h/heisenbug.html)
    (usually hardware- syscall- or compiler-related)
    and [schroedinbugs](http://www.jargon.net/jargonfile/s/schroedinbug.html)
    (usually threading- memory- entropy-related).

    Restated: the more work it would take to instrument, trace, disassemble and
    analyze, the more sense it makes to just rewrite the darn thing.

    There is also an uncertainty coefficient here, refactoring could:

    i. remove the bug outright through simplification (complete win);
    i. remove the bug but introduce unexpected issues e.g. because of
        overly simplistic models etc (tradeoff); or
    i. not only fail to touch the bug but introduce new bugs
        because of code immaturity (pyrrhic victory).


1. Known technical debt but not affecting current performance or reliability.

    Attempting to pay off this debt before it has matured
    (started to manifest negatively in production
    or standing in the way of a new feature),
    will almost certainly result in wasted development resources.

    Or, as eloquently stated by my old boss: *better is the enemy of good*.


## Full Disclosure

90% of the work I do is C and related toolchains (Shell, Makefiles, Meson).
