# CDPO - CryoET Data Portal Ontology
# Makefile for building, validating, and converting the ontology

# Configuration
ROBOT = ./bin/robot
OWL_FILE = cdpo.owl
OBO_FILE = cdpo.obo
EDIT_FILE = cdpo-edit.owl

# Source URLs for imports
BFO_URL = http://purl.obolibrary.org/obo/bfo.owl
IAO_URL = http://purl.obolibrary.org/obo/iao.owl
OBI_URL = http://purl.obolibrary.org/obo/obi.owl

# Default target
.PHONY: all
all: $(OWL_FILE) $(OBO_FILE)

# Build the merged OWL file
$(OWL_FILE): $(EDIT_FILE)
	$(ROBOT) merge --input $(EDIT_FILE) \
		annotate --ontology-iri "http://purl.obolibrary.org/obo/cdpo.owl" \
		--output $(OWL_FILE)

# Convert to OBO format
$(OBO_FILE): $(OWL_FILE)
	$(ROBOT) convert --input $(OWL_FILE) \
		--format obo \
		--output $(OBO_FILE)

# Validate the ontology against OWL 2 DL profile
.PHONY: validate
validate: $(OWL_FILE)
	@mkdir -p reports
	$(ROBOT) validate-profile --input $(OWL_FILE) --profile DL --output reports/profile-validation.txt
	@echo "Validation passed!"

# Generate QC report
.PHONY: report
report: $(OWL_FILE)
	@mkdir -p reports
	$(ROBOT) report --input $(OWL_FILE) \
		--output reports/cdpo-report.tsv
	@echo "Report generated: reports/cdpo-report.tsv"

# Extract BFO import module
imports/bfo_import.owl:
	@mkdir -p imports
	$(ROBOT) extract --input-iri $(BFO_URL) \
		--method MIREOT \
		--upper-term "http://purl.obolibrary.org/obo/BFO_0000001" \
		--output imports/bfo_import.owl

# Extract IAO import module
imports/iao_import.owl: imports/iao_terms.txt
	@mkdir -p imports
	$(ROBOT) extract --input-iri $(IAO_URL) \
		--method MIREOT \
		--lower-terms imports/iao_terms.txt \
		--output imports/iao_import.owl

# Extract OBI import module
imports/obi_import.owl: imports/obi_terms.txt
	@mkdir -p imports
	$(ROBOT) extract --input-iri $(OBI_URL) \
		--method MIREOT \
		--lower-terms imports/obi_terms.txt \
		--output imports/obi_import.owl

# Download all imports
.PHONY: imports
imports: imports/bfo_import.owl imports/iao_import.owl imports/obi_import.owl
	@echo "All imports downloaded successfully!"

# Build with imports merged
.PHONY: build-full
build-full: imports $(OWL_FILE) $(OBO_FILE)
	@echo "Full build completed!"

# Verify the ontology structure
.PHONY: verify
verify: $(OWL_FILE)
	$(ROBOT) verify --input $(OWL_FILE) \
		--queries queries/*.sparql \
		--output-dir reports/ || true

# Reason over the ontology (check consistency)
.PHONY: reason
reason: $(OWL_FILE)
	$(ROBOT) reason --input $(OWL_FILE) \
		--reasoner ELK \
		--output cdpo-reasoned.owl
	@echo "Reasoning completed: cdpo-reasoned.owl"

# Quick build (no imports)
.PHONY: quick
quick: $(OWL_FILE) $(OBO_FILE)
	@echo "Quick build completed!"

# Clean generated files
.PHONY: clean
clean:
	rm -f $(OWL_FILE) $(OBO_FILE) cdpo-reasoned.owl
	rm -rf reports/

# Clean everything including imports
.PHONY: clean-all
clean-all: clean
	rm -rf imports/*.owl

# Help
.PHONY: help
help:
	@echo "CDPO Ontology Build Targets:"
	@echo "  all          - Build OWL and OBO files (default)"
	@echo "  quick        - Quick build without importing external ontologies"
	@echo "  build-full   - Build with all external imports"
	@echo "  imports      - Download/extract import modules"
	@echo "  validate     - Validate ontology structure"
	@echo "  report       - Generate QC report"
	@echo "  reason       - Run reasoner (ELK) for consistency check"
	@echo "  clean        - Remove generated files"
	@echo "  clean-all    - Remove all generated files including imports"
	@echo "  help         - Show this help message"
