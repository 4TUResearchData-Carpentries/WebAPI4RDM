FILES=("Lesson_development/data_files/test_a.csv" "Lesson_development/data_files/test_b.csv" "Lesson_development/data_files/test_c.csv")
DATASET_ID=5ca09d55-dce5-4f9a-b902-276d7691b7ed

for f in "${FILES[@]}"; do
  MD5SUM=$(md5sum "$f" | awk '{print $1}')
  curl -X POST "https://next.data.4tu.nl/v3/datasets/${DATASET_ID}/upload?strict_check=1&md5=${MD5SUM}" \
    --header "Authorization: token ${API_TOKEN}" \
    -F "file=@${f}"
done
