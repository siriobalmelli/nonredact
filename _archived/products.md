---
layout:		default
title:		Where the goal posts are
date:		2018-10-31
categories: articles
---

# Where the goal posts are

I've come to what I feel is a good breakthrough about what the goal posts are
in writing software.

This is an attempt to more precisely gauge when software is "done",
when has an engineer "has done a good job", when to leave a project
alone and not "over-cook", when to dig in and re-factor or even re-write.

A good metric or set of metrics for "well-written software" would answer
not only these questions, but would allow for *clear* and *usable*
critique of "bad" software - rejections or requests for improvement which
are *comprehensible* and have *clear fixes*.

We all agree that software has to "work" and "be useful".

Well, what *are* the component parts of "working" and "useful"?

## Tools and Systems

"Software" can be a general and nebulous term.
Specifically, an engineer produces [tools](https://www.etymonline.com/word/tool)
and [systems](https://www.etymonline.com/word/system#etymonline_v_22548).

Both take input and generate output.

A tool performs a [transformation](https://www.etymonline.com/word/transform?ref=etymonline_crossreference)
or single category of transformations.
It performs some action on an input and yields one or more outputs.

A system is one or more tools, plus:

- tool configuration
- communication/piping between tools
- communication into and out of the system

The terms *tool* and *system* are a matter of perspective,
and they "nest" or "stack", for example:

- a function can be considered a *tool* in the context of a library as a *system*.
- a library can be a *tool* when called by an application as a *system*.
- an application can be a *tool*, and its runtime
	(environment variables, configuration flags, i/o) the *system*.
- a runtime (app+environment) can be a *tool* in an OS/container *system*.
- an OS/container is a *tool* for a deployed service *system*.
- a deployment is a *tool* in redundant or distributed *system*.

This layering is an example of
[abstraction](https://stackoverflow.com/questions/21220155/what-does-abstraction-mean-in-programming).

A tool can only be evaluated in the context of its parent system.

## Metrics

A tool, to be useful, has to:

1. say what it does:
	clear purpose, usable documentation

1. explain what it does:
	tests, examples

1. do what it says:
	give valid output for valid input

1. show what it does:
	useful logging/printing, but only if asked

1. know what it does:
	have a stated purpose and do nothing else

1. be reliable:
	always visibly report errors, never falsely report success

1. be comprehensible:
	easy to understand and modify both code and documentation

The focus is on simplicity: in each of these areas above, if there is
a *simpler* way to achieve the goal, that way is best.

A brilliant reference on the matter is
[Max Kanat-Alexander's Code Simplicity](http://shop.oreilly.com/product/0636920022251.do).
