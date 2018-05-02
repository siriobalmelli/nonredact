---
layout:		default
title:		Intermission - rant re encryption
date:		2018-05-02
categories: articles
---

# Intermission - a quick rant on encryption

My favorite tech business newsletter is by far
	[Ben Thompson's Stratechery Blog](https://stratechery.com/).
I have been a religious subscriber for the last 3 years.

He recently wrote a piece titled [Open, Closed, and Privacy](https://stratechery.com/2018/open-closed-and-privacy/),
	which sparked an e-mail repy on my part that steadily turned into a small article
	on the subject of encryption.

I realized after sending that Ben's was, fortuitously, one of his open Weekly Articles;
	I am happy to be able to reference it here, since my reply would make no
	sense without the original article for context.

## As e-mailed to Mr. Thompson

Hi Ben,

Thank you so much for the amazing work on Stratechery and the in-depth coverage.
I’m a long-term subscriber and very much look forward to your articles.

I want to chime in on the relationship between open/closed and encryption.

From a technical standpoint
(my work is mostly in the Linux kernel and surrounding ecosystem),
these are strictly orthogonal factors (not interdependent).

Please keep in mind that secure public/private key encryption schemes
	have the following properties:
- the public key is, well, public: it can be shared with anyone.
- the algorithms that generate the keys and encrypt/decrypt the data
	are peer-reviewed open-source.
- the protocol(s) for exchanging and validating keys and exchanging
	encrypted data are also peer-reviewed open-source.

Here are 3 ways the problem has already been solved (simplified but not inaccurate):

1. Parties wishing to initiate communication can generate and trade keys
	on the fly.
This is what happens when you visit an HTTPS site today - it is a seamless process
	of key negotiation with proven security.

1. There is existing (you might say "old-school”) free infrastructure for
	distribution and dissemination of public keys.
As an example, here is a search for my public key on a free server:
	<http://pgp.mit.edu/pks/lookup?search=sirio.bm%40gmail.com&op=index>
	… there is software today which will look up an e-mail address to see
	if someone has posted a key for that address, and use that key.

1. There is no technical barrier to efficient distribution of keys
	without having a central server.
I’m not talking about blockchain (though that does lend itself well),
	but about DHTs (Distributed Hash Tables).

TLDR(DHT): all the apps/machines participate in building and maintaining
	a distributed database of keys.
Think of it as little bits of the whole database split up
	amongst all the apps in the network, with lots of redundancy and failover
	built in so data is not lost when apps join and leave the network.

The underlying mathematics for the above methods is well established
	(nothing cutting-edge here) and many solid implementations exist
	as peer-reviewed open source.

I hope this gives enough background to appreciate how,
	from purely an engineering perspective, Google’s decision makes little sense.

Or, put another way: there is no feature of a chat application which cannot be implemented:
- securely
- without infrastructure overhead (aka: in a distributed fashion)
- using existing open-source code

In all fairness, each of these schemes has delicate areas where it is easy to
	over-simplify and compromise security.
The point stands however that there is a large, open mathematical and software
	community continually improving the state of the art;
	Google would have made a welcome addition to this ecosystem.

Make no mistake, this is purely an engineering perspective - no judgement or
	political commentary is implied or intended!
Feel free to share all or any part of this publicly if you are so inclined.

Thanks again for your dedication to what I consider the highest-quality source
	of business insight in our industry.

All the best,

Sirio Balmelli
