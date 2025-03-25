
## Style guide

#### Header convention

For headers it is recommended to use standard sentence structure, i.e. do not capitalize letters apart from the first word, specific terms or acronyms.

For example, use

```markdown
## This header is correct for Movement Labs' MIPs
```

Do not use

```markdown
## This Header is Incorrect for Movement Labs' MIPs
```

#### Capitalization convention

Ensure clarity and consistency in distinguishing between internal components and general roles. When referring to specific entities within our system, capitalize their names. Use lowercase when referring to general roles or concepts. For example:

- **Relayer** refers to our specific relayer, while **relayer** refers to any agent performing relaying.  
- **Validator** refers to our designated validators, while **validator** is a general term for any entity validating transactions.  

#### Note boxes

Avoid using

```markdown
> [!NOTE]
> ...
```

or

```markdown
!!! note ...
```

or

```markdown
::: note ... :::
```

These do not render correctly either in the GitHub preview or in the rendered markdown. Instead use emojis to indicate the type of note, e.g.

```markdown
\> 👀 Note, that ...
\> :warning: This is a warning ..
\> :bulb: Here is something to learn ..
```
