# CDPO - CryoET Data Portal Ontology

An ontology for describing non-biological and non-relevant components observed in cryo-electron tomography (cryo-ET)
data, including sample support materials, contamination, artifacts, and fiducial markers.

## Overview

| Property | Value |
|----------|-------|
| **Prefix** | CDPO |
| **Namespace** |  |
| **License** | [MIT](https://opensource.org/licenses/MIT) |
| **Upper Ontology** | [BFO 2.0](https://basic-formal-ontology.org/) |
| **Formats** | OWL, OBO |

## Class Hierarchy

```
BFO:entity
└── BFO:continuant
    └── BFO:independent continuant
        ├── BFO:material entity
        │   ├── OBI:specimen
        │   ├── CDPO:sample
        │   ├── CDPO:sample support component
        │   │   ├── CDPO:sample support material
        │   │   ├── CDPO:electron microscopy grid
        │   │   └── CDPO:support film
        │   │       ├── CDPO:carbon support film
        │   │       │   ├── CDPO:holey carbon film
        │   │       │   └── CDPO:lacey carbon film
        │   │       ├── CDPO:gold support film
        │   │       │   └── CDPO:holey gold film
        │   │       └── CDPO:support film fragment
        │   ├── CDPO:contamination
        │   │   ├── CDPO:ice particle contamination
        │   │   ├── CDPO:sputter particle contamination
        │   │   └── CDPO:leopard skin contamination
        │   ├── CDPO:sample artifact region
        │   │   ├── CDPO:non-vitreous region
        │   │   ├── CDPO:dose-damaged region
        │   │   ├── CDPO:curtaining artifact region
        │   │   └── CDPO:sample tear
        │   ├── CDPO:fiducial marker
        │   │   ├── CDPO:gold fiducial nanoparticle
        │   │   └── CDPO:gold CLEM label
        │   ├── CDPO:protein aggregate
        │   └── BFO:fiat object part
        │       └── CDPO:tomogram edge
        └── BFO:immaterial entity
            └── BFO:site
                └── CDPO:vacuum region

IAO:information content entity
└── IAO:image
    └── CDPO:tomographic image artifact
        ├── CDPO:tomographic reconstruction artifact
        │   ├── CDPO:unreconstructed region
        │   └── CDPO:streak artifact
        ├── CDPO:sample charging artifact
        ├── CDPO:laser phase plate off-plane artifact
        └── CDPO:laser phase plate off-node artifact
```

## Files

| File | Description |
|------|-------------|
| `cdpo-edit.owl` | Source ontology (edit this file) |
| `cdpo.owl` | Built/merged OWL ontology |
| `cdpo.obo` | OBO format version |
| `Makefile` | Build automation |
| `catalog-v001.xml` | Protege import catalog |

## Building

Requires [ROBOT](http://robot.obolibrary.org/) (included in `bin/`).

```bash
# Build OWL and OBO files
make all

# Validate and generate QC report
make report

# Show all available targets
make help
```

### Build Targets

| Target | Description |
|--------|-------------|
| `all` | Build OWL and OBO files (default) |
| `quick` | Quick build without external imports |
| `validate` | Validate against OWL 2 DL profile |
| `report` | Generate QC report |
| `imports` | Download external import modules |
| `clean` | Remove generated files |

## External Imports

CDPO references terms from:

- **[BFO](http://purl.obolibrary.org/obo/bfo.owl)** - Basic Formal Ontology (upper ontology)
- **[IAO](http://purl.obolibrary.org/obo/iao.owl)** - Information Artifact Ontology (image, information content entity)
- **[OBI](http://purl.obolibrary.org/obo/obi.owl)** - Ontology for Biomedical Investigations (specimen)


### Adding a New Term

1. Assign the next available CDPO ID (e.g., `CDPO:0000034`)
2. Add required annotations:
   - `rdfs:label` - human-readable name
   - `IAO:0000115` - textual definition
3. Add `rdfs:subClassOf` to place in hierarchy
4. Rebuild with `make all`

## Term Summary

| Category | Count |
|----------|-------|
| Sample support components | 10 |
| Contamination types | 3 |
| Sample artifact regions | 5 |
| Fiducial markers | 3 |
| Tomographic image artifacts | 6 |
| Other (vacuum, edge, sample) | 3 |
| **Total CDPO terms** | **33** |

## License

This ontology is released under the [MIT License](https://opensource.org/licenses/MIT).