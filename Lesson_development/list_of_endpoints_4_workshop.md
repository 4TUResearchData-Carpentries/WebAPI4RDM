## Endpoints

### Fetching public data

#### Datasets and software

- "https://data.4tu.nl/v2/articles" (GET info of datasets)
- "https://data.4tu.nl/v2/articles/dataset-uuid" (GET info of a dataset)
- "https://data.4tu.nl/v2/articles/dataset-uuid/files" (GET the files of a dataset)
- "https://data.4tu.nl/file/dataset-uuid/file-uuid" (GET to Download a specific file)

#### Collections

- "https://data.4tu.nl/v2/collections" (GET info of collections)
- "https://data.4tu.nl/v2/collections/collection-uuid" (GET info of a collection)
- "https://data.4tu.nl/v2/collections/collection-uuid/articles" (GET info of the datasets of a collection)



### Searching and fetching data from authors

- "https://data.4tu.nl/v2/articles/search" (POST)
- "https://data.4tu.nl/v2/collections/search" (POST)
- "https://data.4tu.nl/v2/account/authors/search" (POST, TOKEN)
- "https://data.4tu.nl/v2/account/authors/author-id" (GET, TOKEN)

### Searching accounts within your institutions
- "https://data.4tu.nl/v2/account/institution" (GET) This endpoint requires admin privileges 
- "https://data.4tu.nl/v3/groups" (GET) This endpoint lists the groups ID of the institutions that you can use to filter the output of v2/articles/
- One option is to use the python package `connect4tu` (https://github.com/leilaicruz/connect4tu) to retrieve datasets from a specific organization

### Uploading 


#### Metadata uploading

- "https://next.data.4tu.nl/v2/account/articles" (POST, TOKEN)
  - the authors field is only possible via this endpoint, to append more authors it should be used:
  - "https://next.data.4tu.nl/v2/account/articles/dataset-id/authors" (POST, TOKEN)
- "https://next.data.4tu.nl/v2/account/articles/dataset-id" (PUT, TOKEN)  Update metadata with other fields that are not exposed in the v2/account/articles like embargo_options


### File uploading (one file upload per call)

- "https://next.data.4tu.nl/v3/datasets/dataset_id/upload"  (POST, TOKEN ) (it will fail if the dataset passes the allowed initial quota of 10GB)

| Feature                            | `strict_check=0` (default)                          | `strict_check=1` (with `md5` required)                      |
| ---------------------------------- | --------------------------------------------------- | ----------------------------------------------------------- |
| **MD5 hash required?**             | ❌ No                                                | ✅ Yes (`md5=<hash>` in URL)                                 |
| **Reject empty files?**            | ❌ No                                                | ✅ Yes (`d41d8cd98f00b204e9800998ecf8427e`)                  |
| **Duplicate file check (by MD5)?** | ❌ No                                                | ✅ Yes ({"message": "The resource is already available."} if duplicate)               |
| **Integrity verification?**        | ❌ No (only stores computed MD5)                     | ✅ Yes (compares computed MD5 with supplied)                 |
| **Use case**                       | Quick upload, not worried about duplicates          | Critical uploads where file integrity and uniqueness matter |
| **Risk**                           | Possible duplicate uploads and unnoticed corruption | Upload fails if hash mismatch or duplicate detected         |

- Get the MD5SUM of a file :
    - `md5sum path-to-file.csv` (LINUX)
    - `md5 myfile.csv` (MACOS)
    - `Get-FileHash myfile.csv -Algorithm MD5` (Windows)

- `MD5SUM=$(md5sum "/absolute/path/to/localfile.csv" | awk '{print $1}')`
- "https://next.data.4tu.nl/v3/datasets/dataset_id/upload?strict_check=1&md5=${MD5SUM}"

#### Multiple files to upload (demo it if they want)

- Same endpoint as for single files but use it in a loop 


### Submit for review 

- "https://next.data.4tu.nl/v3/datasets/dataset_id/submit-for-review" (PUT, TOKEN) This is the last step when the metadata and the file are uploaded and it is completed

    - That endpoint `/v3/datasets/<id>/submit-for-review` is a **`PUT`** request with a **JSON body** containing the dataset’s final metadata and agreement flags.
    - It can be only be done once, you can not submit twice 
    - Dataset must be unpublished and not already under review (is_published=False, is_under_review=False).


#### **Required parameters in JSON**

From the validation logic:

* `defined_type` — either `"software"` or `"dataset"` (mapped internally to numbers).
* `agreed_to_deposit_agreement` — `true`.
* `agreed_to_publish` — `true`.
* At least one author, keyword (tag), and category must already exist on the dataset in the backend before this call will succeed.
* `license_id` — must be a valid license ID from the repository.
* `title` — string, min 3 chars.
* `description` — string.
* `publisher` — string.
* `language` — string code (e.g. `"en"`).
* `categories` — array of category IDs (must be valid in the system).
* `resource_doi` — must be a valid DOI.

Other fields (`resource_title`, `contributors`, `geolocation`, embargo options, etc.) are optional but can be included.

#### **Example `curl` request**

```bash
curl -X PUT "https://next.data.4tu.nl/v3/datasets/${DATASET_ID}/submit-for-review" \
  --header "Authorization: token ${API_TOKEN}" \
  --header "Content-Type: application/json" \
  --data '{
    "defined_type": "dataset",
    "title": "Wind Tunnel Data for Turbine Blade Aerodynamics",
    "description": "This dataset contains experimental measurements from wind tunnel tests of turbine blades in varying wind conditions.",
    "resource_doi": "10.4121/abcd-efgh", 
    "license_id": 1,
    "publisher": "Delft University of Technology",
    "language": "en",
    "categories": [123, 456],
    "agreed_to_deposit_agreement": true,
    "agreed_to_publish": true,
    "group_id": 1
  }'
```

### Preview images (IIIF)

- "https://data.4tu.nl//iiif/v3/<file_uuid>/<region>/<size>/<rotation>/<quality>.<image_format>" (GET, preview an image or pdf)

    - example: https://data.4tu.nl/iiif/v3/c3eee5e4-1651-4541-8fb4-f240fbd1c4ba/full/!1024,1024/0/default.jpg
    - dataset of the example : https://data.4tu.nl/datasets/8289a903-7ccf-401b-af66-f5b3c9abe4b6/1

- "https://data.4tu.nl/iiif/v3/<file_uuid>"  (GET, context of the image)

    - example: https://data.4tu.nl/iiif/v3/312f1d4a-2b83-491c-b906-a9d5497f6c9d
- "https://data.4tu.nl/iiif/v3/c2a8d5ce-c4ea-46ed-bcdc-e35033e908a8/1/manifest" 
  - To open it in an editor (https://manifest-editor.digirati.services/?tab=recent)