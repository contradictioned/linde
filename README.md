# Linde -- Linear and Independent Equi-Join Data Generator

This data generator is able to generate join data for multiple relations with pairwise specified selectivities.

For example, input for Linde could be:

```json
{
  "relations": {
    "r": { "size": 10000 },
    "s": { "size": 1000 },
    "t": { "size": 5000 }
  },
  "joins": [
    {
      "relations": [
        { "name": "r", "key": "x" },
        { "name": "s", "key": "y" }
      ],
      "selectivity": 0.001
    },
    {
      "relations": [
        { "name": "s", "key": "a" },
        { "name": "t", "key": "b" }
      ],
      "selectivity": 0.01
    }
  ]
}
```

This means, that three relations are generated: r, s, and t, with 10000, 1000, and 5000 tuples each. Further, if the join predicate "r.x = s.y" is applied, it has a selectivity of 0.001, and if the join predicate "s.a = t.b" is applied, it has the selectivity 0.01.

## Quickstart

Take an example from the `example_jobs` folder and call

```
linde <FILE>.json
```
