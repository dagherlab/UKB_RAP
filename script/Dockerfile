# Use a base image with Python
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy the Gauchian repository from GitHub and install it
RUN apt-get update && apt-get install -y git \
    && git clone https://github.com/Illumina/Gauchian.git . \
    && pip install --no-cache-dir . \
    && apt-get remove -y git \
    && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

# Download the reference file
RUN apt-get update && apt-get install -y wget \
    && wget -O GRCh38_full_analysis_set_plus_decoy_hla.fa \
    https://ftp.1000genomes.ebi.ac.uk/vol1/ftp/technical/reference/GRCh38_reference_genome/GRCh38_full_analysis_set_plus_decoy_hla.fa \
    && apt-get remove -y wget \
    && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

# Default command (optional, can be overridden when running the container)
CMD ["gauchian", "--help"]
