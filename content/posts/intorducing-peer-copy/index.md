---
title: Introducing Peer Copy - PCP
description: A fully decentralized peer-to-peer file transfer tool.
image: ./image.jpg
date: 2021-06-06
draft: false
slug: /blog/introducing-pcp
tags:
  - libp2p
  - Testing
  - cli
  - ipfs
  - DHT
---

# Introduction

Individual ﬁle transfer seems to be a solved problem with processes ranging from physically transporting thumb drives to protocols like ftp 3 or smtp 4 , to commercial services like Dropbox 5 . Yet all of these tools require an inconvenient setup procedure. You need to be in physical possession of the thumb drive, you need to have the destination server properly conﬁgured to accept ftp or smtp requests, or both peers need to have an account at the same ﬁle hosting service. A set of tools, most notably croc 6 and magic-wormhole 7 , solve this problem by only requiring the user to transmit a short passphrase to the receiving peer to initiate a ﬁle transfer. They allow the transmission of data without special knowledge about the technical infrastructure employed by the peers. These tools, however, rely on a small set of servers which are usually operated by the maintainers of the open-source projects to orchestrate peer discovery and data relaying [1]. This model of operation poses centralization concerns and puts the service’s sustainable operation in question as a recent issue in the croc repository shows 8 . The small set of private servers constitute single points of failure and an attack target to disrupt the service. Further, the service operators have the power over whom to serve and can gather extensive knowledge about communication patterns.

In this paper, we present Peer Copy (pcp) – a decentralized, peer-to-peer ﬁle transfer tool based on libp2p 9 . Many concepts like the command-line user interface and user experience, as well as the Password-Authenticated Key Exchange (PAKE) [3] and the concept of channels (explained later in section 2) were adapted or reused from croc and magic-wormhole. The novelties of this tool are the extensive architectural diﬀerences in the peer discovery and data relaying mechanisms that render centralized server infrastructure obsolete. The main contribution of this paper is **a decentralized peer discovery mechanism based on low entropy passphrases**.

During usual operation, the pcp process lifecycle can be separated into the stages of peer discovery, peer authentication, and ﬁle transfer. The novelty of pcp lies in the decentralized peer discovery mechanism, which employs multicast DNS (mDNS) 10 and the Distributed Hash Table (DHT) from the Interplanetary File-System (IPFS) [2]. Peer authentication is done via PAKE, where a small number of random words, e.g., four, from the 39th Bitcoin Improvement Proposal (BIP39) 11 serve as a passphrase. File transfer can either be direct or transitive through a libp2p relay node.

The following section 2 describes the functionality and explains how each aforementioned concept relates to and facilitates the ﬁle transfer capabilities of pcp. Section 3 gives an outlook and future improvement opportunities.
