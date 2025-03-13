# algorithms

A place to explore various quantum algorithms.

(Placeholder for math below, for now just some stuff about coset geometries)

# Incidence geometries

Given a bunch of subgroups $`H_{i \; \varepsilon \; \mathcal I}`$ of a group $G$, we can consider the families of $G$-sets $`(G:H_{i})`$ for $`i \; \varepsilon \; \mathcal I`$, where we consider two cosets (of different types) _incident_ if they intersect.

More generally these form an example of an _incidence geometry_, consisting of:

- a set $X$ of _varieties_
- a set $\mathcal T$ of _types_
- a type map $`\tau: X \rightarrow \mathcal T`$ assigning a type to each variety
- a binary _incidence relation_  on $X$

such that distinct varieties of the same type are never incident.

The _rank_ of the geometry is $|\mathcal T|$.

A _flag_ is a set of mutually incident varieties (necessarily of different types)
and a _chamber_ is a flag containing a variety of every type.

We call an incidence geometry _Buekenhout_ if it obeys this "chamber axiom":

- Every flag is contained in a chamber

# Coset geometries

Given a group $G$ with subgroups $`H_{i \; \varepsilon \; \mathcal I} <= G`$, we can consider the families of $G$-sets $`(G:H_{i})`$. 

The _coset geometry_ 
$`\{G  \; ; \; H_{i \; \varepsilon \; \mathcal I}\}`$ consists of:

- varieties = $\sqcup_{i \; \varepsilon \; \mathcal I} (G ; H_i)$, a disjoint union of the cosets of the $`H_i`$
- $\mathcal I$ is the set of types
- the type map $`\tau: X \rightarrow \mathcal I`$ sending each $H_i \rightarrow i$
- cosets are incident if their intersection is nonempty

Clearly this forms an incidence geometry as above, and we'll see that it is Buekenhout if the rank $|\mathcal{I}| <= 3$.

Also G acts on this geometry and is transitive on varieties of each type.

# Basic results about cosets and their geometries

We consider right cosets (abbreviated as just "cosets") of subgroups $`H, K,  \dots`$ of a group G. Write $`Hx \perp Ky`$ to mean that cosets are disjoint, or 
 $`Hx \not \perp Ky`$ otherwise, in which case they _meet_ or are _incident_.

**Proposition 1**
Every coset of $`H`$ meets $`{n}`$ cosets of $`K`$, where $`{n} = |{H:(H \wedge K)}|`$.

When does $`H`$ meet $`Kx`$? Exactly when some `$xh^{-1} \; \varepsilon \; `K$, i.e. $`x \; \varepsilon \; KH`$, and this will count the coset $`Kx`$ just $`|K|`$ times. So this holds with $`n = |{KH}|/|{K}| =|{H:(H \wedge K)}|`$. 

Applying right multiplication, the same holds for any other coset $`Hy`$ of $`H`$. $`\Box`$

**Proposition 2**
When a coset of $`H`$ meets a coset of $`K`$, their intersection has size $`m`$, where $`m = |H \wedge K|`$.

Suppose $`Hx \not \perp Ky`$. If $`z \; \varepsilon \; Hx \wedge Ky`$, we have $`Hx = Hz`$ and $`Ky = Kz`$, so

$`| \; Hx \wedge Ky \; |= |Hz \wedge Kz \; |= |\; (H \wedge K)z \; | = | \; H \wedge K \;|`$. $`\Box`$

**Proposition 3**
When a coset of $`H`$ meets a coset of $`K`$, there is a coset of $`L`$ incident with both of them.

Pick  $`z \; \varepsilon \; Hx \wedge Ky`$. Then clearly $`Lz`$ meets both $`Hx`$ and $`Ky`$. $`\Box`$

This shows that coset geometries of rank $<= 3$ are Buekenhout.
