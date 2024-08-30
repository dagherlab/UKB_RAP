docker build --platform linux/amd64 -t liulang6/gauchian .


# test it (work)
wget ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/1000G_2504_high_coverage/data/ERR3239883/NA20815.final.cram
wget ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/1000G_2504_high_coverage/data/ERR3239883/NA20815.final.cram.crai
echo "$PWD/NA20815.final.cram" > manifest.txt
docker run -v $PWD:$PWD liulang6/gauchian gauchian -m $PWD/manifest.txt -g 38 -o out -p testgba --reference GRCh38_full_analysis_set_plus_decoy_hla.fa


# push it
docker push liulang6/gauchian

# save it
docker save liulang6/gauchian |xz > Gauchian.tar.xz