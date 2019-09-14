---
layout:		default
title:		Digital Identity: GPG keys and subkeys
date:		2019-07-31
categories: articles
---

# Digital Identity: GPG keys and subkeys

This is a set of notes and a guide on managing *digital identity*, meant to:

- gather useful definitions and references in one place
- document current practice for future reference and refinement
- show and comment the commands used to implement

I assume the reader has intermediate experience with computers.

Never fear the command line: it is the only UI where you can scroll back and
see exactly what happened ;)

## Nomenclature

### Digital Identity

This is all the ways of:

1. Proving you are you.

    This is *authentication* or *logging in*.

    - Logging into a computer with *username* and *password*.
    - Logging into `Facebook` with *username* and *password* and a *verification code*.
    - Using OAuth (`log in with Facebook`) to access a website,
(once you log in, they give that site a *token*).

1. Accessing access data meant only for you.

    This is *decryption*.

    - Mounting an encrypted hard drive with a *passphrase*.
    - Decrypting an e-mail encrypted with your *public key*,
using your *private key*.
    - Browser receiving data over an encrypted link (`https://`),
decrypting it using a *session key*.

1. Proving you created something, and it has not been altered since.

    This is *signing*.

    - Signing an e-mail you write (or software package you create)
with your *private key* so recipients can verify it using your *public key*.
    - Transferring money with a cryptocurrency by *signing*
the transaction with your *wallet* (a wallet is just a set of keys)
and then inserting the signed transaction in the public blockchain.

1. Vouch for other digital identities (someone else, or an earlier identity of yours).

    This is *certification*.

    - Joe signs Bill's public key; Bill signs John's public key.
Joe now has a *chain of trust* that he can use to validate John's key
even though he doesn't know John directly.
    - Joe wants to retire his keypair `A`;
he creates a new keypair `B` and signs it with `A`.
There is now a chain of trust back from `B` via `A` to all previous
signatures of `A`.
    - X.509 certificates used in TLS/SSL - a domain's certificate is valid
if there is a *certificate chain* back to a known trusted public certificate.

### Authentication Factors

The general class of mechanism for **how** identity is verified:

- things you know (username, password, answer to a security question)
- things you have (cell phone, e-mail account, gpg key)
- things you are (fingerprint, facial pattern)

Multi-factor (e.g. two-factor) authentication means verification using
more than one of these classes:

- a password (*know*) and smartcard (*have*)
- a password (*know*) and SMS to phone (*have*)
- a phone (*have*) and fingerprint (*are*)

### GPG Key Types and Subkeys

GPG has the following types/functions for keypairs:

| type  | name          | function                                 |
| ----- | ------------- | ---------------------------------------- |
| **C** | Certification | certifies (signs) other keys and subkeys |
| **S** | Signing       | signs data                               |
| **E** | Encryption    | decrypts received data                   |
| **A** | Auth          | authenticates logins                     |

A "primary" or "master" key is always **C** key (may *also* be **S**),
and it *certifies* (signs) *sub-keys*.

With a GPG default key there is an **E** sub-key to handle crypto.

A **C** key is also needed to *trust* (sign) other keys,
and it is the **C** key which is *trusted* by other keys.

This makes the primary **C** key more important:
it is the one that is trusted by others, and it can revoke and sign new subkeys.

### Smartcards

These are also called *hardware encryption devices* or *security tokens*;
physical hardware that holds keys and handles crypto operations.

Some examples:

- [YubiKey]
- [LibremKey]

See also GPG's [Smartcard] documentation.

## Strategy

1. Generate a **C**-only master key using Ed25519.

    - This key will be long-lived: [Ed25519] chosen because reasonably
wide implementation and low likelihood of compromise in the near future.
    - Previous keys can sign this new key (key-rollover) and then be
expired or revoked (according to preference).

1. Generate **S, E, A** sub-keys signed with the master key, for everyday use.

    - Signed by the master key: can be easily revoked and replaced.
    - Can be moved to a [Smartcard]: theft/loss/breakage is not a problem.
    - Different passphrase than the master key:
keylogger or OS compromise does not compromise the master key.

1. Store the master key offline, [scrypt]-encrypted.

    - Second layer of encryption on top of [gpg]'s passphrase.
    - Offline so that a compromised system can only expose subkeys but not the master.
    - Stored on a USB stick or similar with very standard filesystem (e.g. FAT32)
so recovery is possible on any system.
    - Stored in more than one place: multiple USB sticks.

    It is not a good idea to store master key *only* on a [Smartcard]:
    once a key is on a smartcard it cannot be retrieved/recovered.
    There would have to be *many* [Smartcard] tokens containing the master key,
    to guarantee survival against loss/theft/breakage over many years.

1. When master key is needed, decrypt it from offline storage into `~/.gnupg`.

    *optionally*: Use an air-gapped system to decrypt offline master key,
    then load it into a [Smartcard] and connect smartcard only when
    master key is needed.

## Implementation

1. Tools:

    - [gpg] v2.2.5 or greater
    - [paperkey]
    - [scrypt]

1. Configure `gpg`:

    ```bash
    # make sure we have gpg; create ~/.gnupg
    $ gpg -K
    gpg: directory '/home/admlocal/.gnupg' created
    gpg: keybox '/home/admlocal/.gnupg/pubring.kbx' created
    gpg: /home/admlocal/.gnupg/trustdb.gpg: trustdb created

    # proper permissions
    $ touch ~/.gnupg/gpg.conf
    $ touch ~/.gnupg/gpg-agent.conf
    $ chmod -R go-rwx ~/.gnupg

    # suggested GPG configuration, see comments next to each point
    $ cat >~/.gnupg/gpg.conf <<EOF
    ##
    # formatting and character handling
    ##
    charset utf-8
    no-mangle-dos-filenames

    # get rid of the copyright notice
    no-greeting
    no-emit-version

    # List all keys (or the specified ones) along with their fingerprints
    with-fingerprint
    # show key keygrip (used for filename on disk)
    with-keygrip


    ##
    #   security
    ##
    # Display long key IDs
    keyid-format 0xlong

    # When verifying a signature made from a subkey, ensure that the cross
    # certification "back signature" on the subkey is present and valid.
    require-cross-certification

    cert-digest-algo SHA512
    default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 CAMELLIA256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed
    personal-digest-preferences SHA512 SHA384 SHA256 SHA224
    personal-cipher-preferences AES256 CAMELLIA256 AES192 AES CAST5
    personal-compress-preferences ZLIB BZIP2 ZIP Uncompressed

    # when signing, be precise about amount of trust
    ask-cert-level

    # trust levels order:
    # unknown < undefined < marginal < fully < ultimate < expired < never
    trust-model tofu+pgp
    tofu-default-policy ask

    # any reasonable O/S should provide this
    require-secmem

    # always know at a glance which User IDs gpg thinks
    # are legitimately bound to the keys in keyring
    verify-options show-uid-validity
    list-options show-uid-validity


    ##
    #   keyservers
    ##
    # When using --refresh-keys, if the key in question has a preferred keyserver
    # URL, then disable use of that preferred keyserver to refresh the key from
    keyserver-options no-honor-keyserver-url

    # When searching for a key with --search-keys, include keys that are marked on
    # the keyserver as revoked
    keyserver-options include-revoked
    keyserver-options include-subkeys

    # modified list, so that we are compatible with gpg2 (used by pass)
    auto-key-locate ldap keyserver

    # last keyserver listed is the first one gpg will try
    # no guarantee it will fall back on the others but one would assume so
    keyserver hkps://keys.fedoraproject.org
    keyserver hkps://pgp.mit.edu
    keyserver hkps://keys.gnupg.net

    auto-key-retrieve
    EOF

    $ cat >~/.gnupg/gpg-agent.conf <<EOF
    # do not cache secret key passwords for a long time
    default-cache-ttl 30
    max-cache-ttl 60
    EOF
    ```

1. Create keys:

    ```bash
    # create cert-only master key
    # use a strong passphrase for this key
    $ gpg --quick-gen-key bilbo@baggins.shire future-default cert 1y

    gpg: key 0x9ECD1297468DB871 marked as ultimately trusted
    # Pay attention to this revocation cetificate, will be needed later.
    gpg: revocation certificate stored as '/home/admlocal/.gnupg/openpgp-revocs.d/82CDE848161052594C9303C69ECD1297468DB871.rev'
    public and secret key created and signed.

    # 0x9ECD1297468DB871 is the KEY_ID of the master key.
    # C == Certification
    pub   ed25519/0x9ECD1297468DB871 2019-07-30 [C] [expires: 2020-07-29]
          Key fingerprint = 82CD E848 1610 5259 4C93  03C6 9ECD 1297 468D B871
          Keygrip = AE9514048662882E0609A349491637E661F5F6DB
    # Keygrip can be used to find the filenames of keys on disk.
    uid                              bilbo@baggins.shire


    # add subkeys for signing, authentication and encryption
    $ for t in sign auth encr; do
        gpg --quick-add-key "82CD E848 1610 5259 4C93  03C6 9ECD 1297 468D B871" future-default $t 1y
    done
    $


    # add any additional UIDs
    $ gpg --quick-add-uid bilbo@baggins.shire bilbo@rivendell
    # the last UID added is set to "primary"
    # if this is not the desired primary, set it expicitly
    $ gpg --quick-set-primary-uid bilbo@rivendell bilbo@baggins.shire


    # inspect final keyring
    $ gpg -K

    sec   ed25519/0x9ECD1297468DB871 2019-07-30 [C] [expires: 2020-07-29]
          Key fingerprint = 82CD E848 1610 5259 4C93  03C6 9ECD 1297 468D B871
          Keygrip = AE9514048662882E0609A349491637E661F5F6DB
    uid                   [ultimate] bilbo@baggins.shire
    uid                   [ultimate] bilbo@rivendell
    ssb   ed25519/0x960DAF3197FBD956 2019-07-30 [A] [expires: 2020-07-29]
          Keygrip = 356EE0ED18D3997846C487D0F60243DED38D6BFD
    ssb   ed25519/0xE2BDDBC750B6D89A 2019-07-30 [S] [expires: 2020-07-29]
          Keygrip = BF35734F901675DDD6E40A8C694B90744604E9A0
    ssb   cv25519/0xB900B34FEBDBA83C 2019-07-30 [E] [expires: 2020-07-29]
          Keygrip = 4CBCC3179D7EDC519698A51FA0D903508216BE6B


    # Set master key as default key in keyring:
    cat >>~/.gnupg/gpg.conf <<EOF
    default-key 0x9ECD1297468DB871
    default-recipient-self
    EOF
    ```

1. Print key recovery and revocation data for safekeeping.

    After printing, delete the revocation certificate since if compromised
    it can be used against you to invalidate your master key.

    Note that the 1-year expiry for all keys means that even if all printed data
    is lost and the digital is lost (or the passphrase forgotten),
    it will no longer be valid in 1 year.

    ```bash
    $ gpg --export-secret-key 0x9ECD1297468DB871 | (umask 0077; paperkey >secret_paper.txt)
    # Now print (or if you are paranoid, manually write out):
    # - secret_paper.txt
    # - ~/.gnupg/openpgp-revocs.d/350CDD3CB0072F2EAE24AABA01ABE64C425DFC96.rev
    # How to do this is specific to your setup.
    # Here is an example for a linux or macOS machine:
    $ cat secret_paper.txt | lpr
    $ cat ~/.gnupg/openpgp-revocs.d/82CDE848161052594C9303C69ECD1297468DB871.rev | lpr
    # However you print, best to avoid e-mailing or transmitting these files
    # on any system that has memory (e.g. e-mail).
    # After you have printed these files, delete them:
    $ rm -f secret_paper.txt ~/.gnupg/openpgp-revocs.d/82CDE848161052594C9303C69ECD1297468DB871.rev
    ```

1. *optional*: roll over old keys:

    ```bash
    # assuming there is an old key we want to replace with our new key:
    $ gpg -K
    sec   rsa2048/0xAA2F5F3376EAAC78 2019-07-30 [SC] [expires: 2021-07-29]
          Key fingerprint = EEA0 24EF 5740 C5DB C9FE  B7C5 AA2F 5F33 76EA AC78
          Keygrip = 7D3407D628C0E6BBA08AE047195C10B3F4C8EBA4
    uid                   [ultimate] bilbo@bag-end.shire
    ssb   rsa2048/0x21ADACAC32B691C1 2019-07-30 [E]
          Keygrip = 57370469BA1E87E2376ACB3EB20C77D29C7B28DB


    # expire the key and all subkeys
    gpg  --quick-set-expire "EEA0 24EF 5740 C5DB C9FE  B7C5 AA2F 5F33 76EA AC78" 1d

    # Generate a revocation certificate in case you may want to revoke the key later.
    # Include the KEY_ID of the new key saying "superseded by"
    $ gpg --gen-revoke 0xAA2F5F3376EAAC78

    sec  rsa2048/0xAA2F5F3376EAAC78 2019-07-30 bilbo@bag-end.shire

    Create a revocation certificate for this key? (y/N) y
    Please select the reason for the revocation:
      0 = No reason specified
      1 = Key has been compromised
      2 = Key is superseded
      3 = Key is no longer used
      Q = Cancel
    (Probably you want to select 1 here)
    Your decision? 2
    Enter an optional description; end it with an empty line:
    > superseded by 0x9ECD1297468DB871
    > 
    Reason for revocation: Key is superseded
    superseded by 0x9ECD1297468DB871
    Is this okay? (y/N) y
    # ... output elided for clarity
    # You will see the revocation certificate in '~/.gnupg/openpgp-revocs.d'


    # Sign new key with old key.
    # This is done with a non-revocable trust signature (nrt), so if old key
    # is compromised it cannot affect chain of trust int he future.
    $ gpg -u 0xAA2F5F3376EAAC78 --edit-key 0x9ECD1297468DB871 nrtsign
    Secret key is available.

    sec  ed25519/0x9ECD1297468DB871
         created: 2019-07-30  expires: 2020-07-29  usage: C   
         trust: ultimate      validity: ultimate
    ssb  ed25519/0x960DAF3197FBD956
         created: 2019-07-30  expires: 2020-07-29  usage: A   
    ssb  ed25519/0xE2BDDBC750B6D89A
         created: 2019-07-30  expires: 2020-07-29  usage: S   
    ssb  cv25519/0xB900B34FEBDBA83C
         created: 2019-07-30  expires: 2020-07-29  usage: E   
    [ultimate] (1). bilbo@baggins.shire
    [ultimate] (2)  bilbo@rivendell

    Really sign all user IDs? (y/N) y

    sec  ed25519/0x9ECD1297468DB871
         created: 2019-07-30  expires: 2020-07-29  usage: C   
         trust: ultimate      validity: ultimate
     Primary key fingerprint: 82CD E848 1610 5259 4C93  03C6 9ECD 1297 468D B871

         bilbo@baggins.shire
         bilbo@rivendell

    This key is due to expire on 2020-07-29.
    How carefully have you verified the key you are about to sign actually belongs
    to the person named above?  If you dont know what to answer, enter "0".

       (0) I will not answer. (default)
       (1) I have not checked at all.
       (2) I have done casual checking.
       (3) I have done very careful checking.

    # NOTE careful checking
    Your selection? (enter '?' for more information): 3
    Please decide how far you trust this user to correctly verify other users keys
    (by looking at passports, checking fingerprints from different sources, etc.)

      1 = I trust marginally
      2 = I trust fully

    # NOTE full trust
    Your selection? 2

    Please enter the depth of this trust signature.
    A depth greater than 1 allows the key you are signing to make
    trust signatures on your behalf.

    # new key can continue the chain of trust from the old key
    Your selection? 5

    Please enter a domain to restrict this signature, or enter for none.

    Your selection? 

    Are you sure that you want to sign this key with your
    key "bilbo@bag-end.shire" (0xAA2F5F3376EAAC78)

    I have checked this key very carefully.

    Really sign? (y/N) y

    gpg> save
    $


    # Sign old key with new key.
    # This IS revocable, so if old key is later compromised the new key
    # can revoke trust.
    $ gpg -u 0x9ECD1297468DB871 --edit-key 0xAA2F5F3376EAAC78 tsign
    # ... output elided, same as above
    # NOTE however that "depth" should be 1: old key CANNOT sign for new key.
    ```

1. Archive master key on offline media (e.g. USB key):

    ```bash
    # use scrypt: gpg already encrypted the key file so mix things up just in case
    $ scrypt enc ~/.gnupg/private-keys-v1.d/AE9514048662882E0609A349491637E661F5F6DB.key \
        /mnt/vault/AE9514048662882E0609A349491637E661F5F6DB.key.scrypt
    Please enter passphrase:
    Please confirm passphrase:
    $ rm ~/.gnupg/private-keys-v1.d/AE9514048662882E0609A349491637E661F5F6DB.key
    # If you now do a `gpg -K` you will see a '#' next to the master key,
    # showing the private key is missing.


    # When master key is needed in the future, reverse this process by
    # mounting offline media and then decrypting directly back into 'private-keys-v1.d'
    $ (umask 0077; scrypt dec \
        /mnt/vault/AE9514048662882E0609A349491637E661F5F6DB.key.scrypt \
        ~/.gnupg/private-keys-v1.d/AE9514048662882E0609A349491637E661F5F6DB.key)
    Please enter passphrase:

    # When finished, just erase it
    $ rm ~/.gnupg/private-keys-v1.d/AE9514048662882E0609A349491637E661F5F6DB.key
    ```

1. After archiving master key, change password on subkeys.

    This will re-encrypt subkeys with a *different* password from the master key,
    so that if a keylogger compromises them,
    the master key remains safe and can be used to revoke and generate new subkeys.

    ```bash
    $ gpg --edit-key 0x9ECD1297468DB871
    Secret subkeys are available.

    pub  ed25519/0x9ECD1297468DB871
         created: 2019-07-30  expires: 2020-07-29  usage: C
         trust: ultimate      validity: ultimate
    ssb  ed25519/0x960DAF3197FBD956
         created: 2019-07-30  expires: 2020-07-29  usage: A
    ssb  ed25519/0xE2BDDBC750B6D89A
         created: 2019-07-30  expires: 2020-07-29  usage: S
    ssb  cv25519/0xB900B34FEBDBA83C
         created: 2019-07-30  expires: 2020-07-29  usage: E
    [ultimate] (1). bilbo@baggins.shire
    [ultimate] (2)  bilbo@rivendell

    gpg> passwd
    gpg: key 0x9ECD1297468DB871/0x9ECD1297468DB871: error changing passphrase: No secret key
    # NOTE this error is EXPECTED
    # If you do not get this error then the master key is still in your ~/.gnupg keyring

    gpg> save
    $
    ```

1. *optional* move your subkeys into a smartcard,
[Librem Key](https://puri.sm/products/librem-key/) or similar.

    This is untested by the author, but should involve something like:

    ```bash
    gpg --edit-key 0xAA2F5F3376EAAC78 keytocard
    ```

    NOTE that once on a smartcard, a key cannot be extracted, so before moving
    to a smartcard it may be a good idea to use `scrypt` to save a copy
    to an offliune vault like for the master key above.

    NOTE: the [SoloKey](https://github.com/solokeys/solo) is very interesting.

1. publish new key and any modified keys:

    ```bash
    gpg --send-key 0x9ECD1297468DB871
    gpg --send-key 0xAA2F5F3376EAAC78
    ```

1. key maintenance:

    Periodic key maintenance is important to:

    - remember the master key and scrypt passphrases
        (since these are not used every day and never written down)
    - prevent key expiration by accident
    - maintain a public record showing a key is actively maintained
    - re-send the public key to keyservers, making sure it will be found if searched for

    ```bash
    # mount the offline storage for your master key, here it is '/mnt/vault',
    # then decrypt directly back into 'private-keys-v1.d'
    $ (umask 0077; scrypt dec \
        /mnt/vault/AE9514048662882E0609A349491637E661F5F6DB.key.scrypt \
        ~/.gnupg/private-keys-v1.d/AE9514048662882E0609A349491637E661F5F6DB.key)
    Please enter passphrase:

    # note this is the FINGERPRINT of the master key
    gpg --quick-set-expire "EEA0 24EF 5740 C5DB C9FE  B7C5 AA2F 5F33 76EA AC78" 1y
    # run again with '*' to update expiry on subkeys
    gpg --quick-set-expire "EEA0 24EF 5740 C5DB C9FE  B7C5 AA2F 5F33 76EA AC78" 1y '*'

    # send update public key out to every keyserver configured in gpg.conf
    for a in $(sed -nE 's/^keyserver (.*)/\1/p' ~/.gnupg/gpg.conf); do
        gpg --keyserver "$a" --send-key 0x9ECD1297468DB871
    done

    # delete secret key (it is unchanged by updating of expiry)
    $ rm ~/.gnupg/private-keys-v1.d/AE9514048662882E0609A349491637E661F5F6DB.key
    ```
## useful references

- <https://eligible.com/blog/commit-signing-with-git-hub-keybase-and-gpg/>
- <https://incenp.org/notes/2015/using-an-offline-gnupg-master-key.html>
- <https://opensource.com/article/19/4/gpg-subkeys-ssh>
- <https://riseup.net/en/security/message-security/openpgp/best-practices>
- <https://sungo.wtf/2016/11/23/gpg-strong-keys-rotation-and-keybase.html>
- <https://wiki.debian.org/Subkeys?action=show&redirect=subkeys>
- <https://www.gnupg.org/gph/en/manual.html>
- <https://www.void.gr/kargig/blog/2013/12/02/creating-a-new-gpg-key-with-subkeys/>

[ed25519]: https://ed25519.cr.yp.to/
[gpg]: https://github.com/gpg
[paperkey]: https://www.jabberwocky.com/software/paperkey/
[scrypt]: https://www.tarsnap.com/scrypt.html
[YubiKey]: https://www.yubico.com/
[LibremKey]: https://puri.sm/products/librem-key/
[Smartcard]: https://wiki.gnupg.org/SmartCard
