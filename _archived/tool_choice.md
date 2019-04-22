---
layout:		default
title:		Tool Choice
date:		2019-04-22
categories: articles
---

# Choice of Tools, aka: The Best Language

This is an article about *"choosing the best tool for the job"*, which is
another form of the question:

*"what programming language should I study?"*

It was prompted by three separate, coincident events:

1. A prospective client asked for a summary of qualifications.
1. A fellow programmer asked what tools I thought he should be studying.
1. Trying to prioritize which new languages and technologies to learn.

I was mystified by the first, flattered by the second, frustrated by the third:

**there is no "best" language/toolchain, no one-size-fits-all approach,
no ideal solution which *remains* ideal over time.**

NOTE: I use the terms *language* and *tool* loosely and somewhat
synonymously here.

I'm under no impression they are the same thing, but in this context they include
each other: no language can be used without related tools (compilers/interpreters),
and no tools can be used without at least some knowledge of the input grammar
they are expecting.

## The Problem

1. Language selection is influenced by the problem domain:
    a language is only *best* in the context of a specific problem.

1. The *best* language for problem X today,
    may not be the best language for that same problem tomorrow.

Naively, the solution would be to just learn every language.
Then one would know which one the *"right"* one is for each project.
This approach is broken:

**The tech landscape is extremely diverse,
yet the market rewards specialization and deep knowledge.**

Diversity is increasing, driven by:

1. New research
1. The computerization of everything

Market reward for specialization is increasing, driven by the cost of:

1. Human I/O limitations:
    - time to learn or teach languages, tools and best practices
    - time to bring programmers up to speed on a codebase

1. Infrastructure:
    - project tooling (build/deploy scripts, hacks, fixes)
    - language infrastructure (documentation, compilers/interpreters, standards)
    - maturity (case studies, FAQs, technical literature)
    - external code reuse (libraries, frameworks)

So, there is no "learn language X and you will fly",
and anyone on a soapbox along those lines is suspect in my book.

## The Solution: A Theory

The idea is that:

**Simplicity is a good gauge of the value or relevance of languages.**

Supposing that computers exist to help humans store, analyze and communicate data:

1. A wheel is a wheel by any name:
    - Computer Science is the link between how humans think of data and how
        computers can be made to represent and manipulate that data.
    - The same few CompSci basics crop up in every language in one form or another.
    - The way to truly learn computer science is to apply it.
        This means writing code.

1. Mental models are more important than languages:
    - Classical (non-quantum) computers all process data in similar ways.
    - Mental models are the link between CompSci theory and code (implementation).
    - The way to write good code in any language is to develop a powerful
        mental model for how computers process data.

1. The value of tools is only the value of the results we can get with them:
    - Code is not an end in itself, the desired result is useful work
        done by computers.

So:

```
Humans <-(Computer Science)-> Structured Data <-(Mental Model)-> Code
```

Simplicity is useful at all levels:

- *humans*: Simplifying our view of the world
    reduces the amount of data needed to represent it.
- *structured data*: Simplifying representation of data
    reduces the complexity of algorithms needed to manipulate it.
- *code*: Simplifying code increases performance,
    reduces bugs, shortens time to debug and time to add new features.

Simplicity speeds computation for both humans and computers.

There is much to be read on the subject, see [bibliography here](./2018-08-18.md).

## Simplicity in Language Selection

Language selection is gaging the compromise between costs such as:

- time to learn vs. time to implement
- continuing education vs. code maintenance
- code reuse vs. ecosystem/community
- new feature implementation vs. testing/debugging

Language selection can be described as an attempt to find the shortest (simplest)
trajectory between existing conditions and desired computer action,
in a 4D space with the following axes:

| axis                         | limits                 |
| ---------------------------- | ---------------------- |
| programmer knowledge         | `existing -> required` |
| solution complexity          | `trivial -> complex`   |
| implementation cost          | `trivial -> complex`   |
| maintenance/improvement cost | `low -> high`          |

Two engineers with different backgrounds, looking at the same problem domain,
might rationally chose different languages, and *they would both be right*.

The same engineer, looking at different problem domains, might rationally
chose different languages, and *they would be right*.

The same engineer might chose different languages for the same problem domain
at different points in time and *they would be right both times*.

## The Solution: In Practice

Here are notes on languages/tools I am focusing on or avoiding,
what problems I am tackling with them,
why I think these are the simplest,
any alternatives I discarded and why.

These are my opinions, in the present,
subject to change as I evolve into a better and more pragmatic coder.

Just because these are best for me does not mean they are best for you
(or even that I am right - they may not be best for me, but my judgement is
limited by the finite amount of information I can process).

### Interfacing and controlling a computer and its programs

[BASH](https://www.gnu.org/software/bash/) is the tool of choice:

- Available on the vast majority of machines: Linux and UNIX (macOS is a UNIX).
- Usually faster than using a mouse on a GUI interface.
- can be *entirely* scripted:
    everything I can do in a terminal I can write in a shell script,
    and those few times where it must be interactive I can use
    [expect](https://core.tcl.tk/expect/index).
- Can interact with machines remotely over SSH without learning a different
    interface.
- Decades of prior art, lots of usage conventions, FAQs, examples, FOSS code.
- Available on minimal systems that can't run a GUI, even the most stripped down
    systems are going to at least have [dash](https://en.wikipedia.org/wiki/Debian_Almquist_shell)
    which is a very useful subset.

In selecting this, I have rejected other shells:

- [ksh](https://en.wikipedia.org/wiki/Korn_shell),
    [csh](https://en.wikipedia.org/wiki/C_Shell),
    [zsh](https://www.zsh.org/): less used and supported, not enough apparent
    gain in functionality to offset the learning curve (I just happened to have
    learned BASH first, starting with Linux 2.4 in the early 2000's).
- [fish](https://fishshell.com/): a better shell, but does not seem *sufficiently*
    better for me to modify almost a hundred scripts I maintain.
    Not guaranteed available on *all* systems.

I have deprioritized GUI interfaces (KDE, GNOME, macOS Aqua, etc, etc);
solving a problem with BASH means I am not locked into a particular GUI.

For any task I want to accomplish, I first search to see if there is already a
FOSS terminal utility which will do it,
and if so I use it directly or write a BASH script to make use of it for me.

BASH is the simplest tool for when I want to:

- start, orchestrate and control programs
- search for files, do arbitrary manipulations on them
- automate (and document) a series of steps or a workflow

### editing files and writing code

I use [vim](https://www.vim.org/) for that:

- opens and processes files quickly
- very efficient interface, very fast text output once I learned to use it
- available on pretty much every system out of the box (or at least a very
    usable subset in the form of [vi](https://www.ccsf.edu/Pub/Fac/vi.html))
- keeps me from depending on a GUI (see previous section)
- been around forever, lots of documentation
- has plug-ins to turn it into an effective IDE for any language
    (e.g. <https://github.com/Valloric/YouCompleteMe>)
- can be customized and extended as needed

I should probably be using [neovim](https://neovim.io/) but vim works quite
well for me so far, so not enough of a pain point to switch (yet).

I did try to switch to [emacs](https://www.gnu.org/software/emacs/) at one
point, but gave up after 40 hours or so.
It probably really is a better text editor but the learning curve is merciless
and variable scoping in LISP still gives me nightmares.

### version control

I use [git](https://git-scm.com/) for version control:

- supremely good at version control
- rather steep learning curve, but very powerful once mastered
- ubiquitous in FOSS projects (notably the Linux kernel)

I used [svn](https://subversion.apache.org/) years ago and Git has been
an upgrade in every way.

It would take a tenfold improvement in version control to justify re-evaluating
the use of Git in favor of another tool.

### setting up tools and an operating environment

How to:

- ensure that the systems I work on (both Linux and macOS) all have
    the exact same tools and environment variables that I prefer?
- propagate changes/upgrades/bugfixes of my environment to all my machines?
- hop between different Linux distros and macOS with no loss of productivity?
- bundle tool dependencies directly with software projects?

[nix](https://nixos.org/nix/) is the tool of choice.

In-depth explanation of my usage is in
[my toolbench repo](https://github.com/siriobalmelli/toolbench#why).
That same repo also lists every tool in my environment,
see [the nix file](https://github.com/siriobalmelli/toolbench/blob/master/default.nix).

There is [guix](https://www.gnu.org/software/guix/) as an alternative,
but I don't already know [guile](https://www.gnu.org/software/guile/) so felt
like it would be a longer learning curve.

I also discovered [vagrant](https://www.vagrantup.com/) after I had been playing
with Nix for a while.
I was out of time to investigate something else, so Nix it is for now.

### analyze data, test algorithms, implement high-level logic

This is where terseness of implementation, code reuse, cross-platform
capabilities and reviewability of code are important,
rather than I/O/compute/memory efficiency or hardware optimization.

[python3](https://www.python.org/) is the language of choice:

- simple and versatile
- very active community, good mindshare, a lot of libraries
- painless learning curve coming from a C background
- very good interpreter implementation [ipython](https://ipython.org/)

I have discarded:

- [ruby](https://www.ruby-lang.org/en/): seems to be a very good language,
    but I know of nothing Ruby can do that Python can't (and vice-versa).
    The first high-level projects I worked on happened to be Python and
    I see no reason to dilute my focus by adding Ruby at this point.
- [perl](https://www.perl.org/): kludgy.
    I prefer BASH for tool control and I prefer Python for high-level logic.
- [C#](https://en.wikipedia.org/wiki/C_Sharp_%28programming_language%29):
    back when I was coding in C# and would have preferred to deepen my
    specialization, as opposed to moving to Python, it was a Microsoft-only
    sandbox and [mono](https://www.mono-project.com/) was a disdained outsider.
    Now that I've made the move to Python I see no advantage in C# over python
    for what I'm doing.
- [PHP](https://www.php.net/): it's a badly designed language and I dislike it.
- [javascript](https://www.javascript.com/): personal dislike for the syntax,
    not maintaining any front-end code so not yet forced to use it.

#### a note on functional languages

I'm very excited by languages such as [haskell](https://www.haskell.org/),
but haven't run into a problem space where the apparent simplicity gain in the
implementation offsets the learning curve.

A couple attempts to grok Haskell on my own time led straight into a morass
of category theory and set theory.
This stuff is a bit tricky for a non-mathematician,
and finding simple definitions was a struggle.

I'm sure better resources will appear as the community grows and the language
matures.

### efficient compute and I/O, embedded devices, kernel hacking

This is the province of [C](https://www.haskell.org/), on account of:

- Straightforward mapping between the language and the compiled result
    (easy to predict what the assembly output will look like).
- Venerable pedigree of code back to the early 70s,
    enormous body of literature and best practices.
- 2 comprehensive FOSS toolchains: [gcc](https://gcc.gnu.org/) and
    [clang](https://clang.llvm.org/), both of which include debuggers.
- Both gcc and clang support [inline assembly](https://en.wikipedia.org/wiki/Inline_assembler)
    for very specific control over compiled output.
- Most comprehensive hardware support of any language except assembly itself.
- Enormous community and support base, the FOSS Linux and FreeBSD kernels among
    many other projects.

I have rejected:

- [C++](https://en.wikipedia.org/wiki/C%2B%2B): unjustified complexity penalty
- [rust](https://www.rust-lang.org/): complexity, instability

I have done some work with [Go](https://golang.org/) and love the language.

Go is already my language of choice for any projects which should be compiled
for performance reasons, but which don't rely on a lot of the C-specific bag of
tricks I've developed over time.

As I learn the implementation more deeply I will probably use Go more and
more over C.
At any rate I don't see C going away any time soon and consider my investment
in learning it well justified.

## Closing

I hope this, admittedly quite long, monograph can shed some light not on
*what's better*, but on *how to choose*.
Teach a man to fish, and all that.

Happy hacking.
