perl SNPInfoGenerate.pl  -f ../../example/BaumanniiMDR-TJ-example.fasta -p 0.01 -r 0.7,0.3 > test-SNP-config
perl ../../bin/Psim.pl  variation  --ref ../../example/BaumanniiMDR-TJ-example.fasta --snp test-SNP-config --sv 0 
mv NewReferenceSequence.fa NewSeq1.fa
mv SNPReportByPsim.txt SNPReport1.txt 
perl ../../bin/Psim.pl  variation  --ref ../../example/BaumanniiMDR-TJ-example.fasta --snp test-SNP-config --sv 0 
mv SNPReportByPsim.txt SNPReport2.txt
mv NewReferenceSequence.fa NewSeq2.fa
vi NewSeq1.fa 
vi NewSeq2.fa
cat NewSeq1.fa NewSeq2.fa  > NewSeq.fa
cp NewSeq.fa ../../output/SNP-test/data/
