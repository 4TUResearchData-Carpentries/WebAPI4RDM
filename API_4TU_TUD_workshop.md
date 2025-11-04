---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.18.1
  kernelspec:
    display_name: webapi
    language: bash
    name: bash3
---


## Why is it important to use Web APIs for research?

Web APIs help automate access to research data and metadata. This enables reproducibility, automation of data pipelines, and programmatic interaction with repositories like 4TU.ResearchData.


## REST APIs in a nutshell

A REST API is a web service that uses HTTP methods (GET, POST, etc.) to allow communication between clients and servers. Responses are usually in JSON format, making them easy to parse and reuse.


## 1. REUSE: Search and Download Datasets


### Get datasets or software deposited in 4TU (via `curl`) 
     

```bash
curl -X GET "https://data.4tu.nl/v2/articles"  | jq
```


## What is curl?

curl stands for **Client URL**. 

It’s a command-line tool that allows you to transfer data to or from a server using various internet protocols, most commonly HTTP and HTTPS.

It is especially useful for making API requests — you can send GET, POST, PUT, DELETE requests, upload or download files, send headers or authentication tokens, and more.

## Why curl works for APIs

REST APIs are based on the HTTP protocol, just like websites. When you visit a webpage, your browser sends a GET request and displays the HTML it gets back. When you use curl, you do the same thing, but in your terminal. For example: 

`curl https://data.4tu.nl/v2/articles` This sends an HTTP GET request to the 4TU.ResearchData API.

## Key reasons why curl is used:

It’s built into most Linux/macOS systems and easily installable on Windows.

Scriptable: usable in bash scripts, notebooks, automation.

Supports headers, query parameters, tokens, POST data, etc.

Can output to files (>, -o, -O) or pipe to processors like jq.


### Add parameters to the same endpoint to filter results 

- open the documentation: https://djehuty.4tu.nl/ (apologies by the documentation, it is also incomplete , we will try to make it better.....)


```bash 

curl "https://data.4tu.nl/v2/articles?limit=2&published_since=2025-05-01" > data.json
```

```bash
curl "https://data.4tu.nl/v2/articles?limit=2&published_since=2025-05-01" | jq
```

### Exercise : request **10** **datasets** published from **January 1st 2025** and show it in the screen

```bash
curl "https://data.4tu.nl/v2/articles?item_type=3&limit=10&published_since=2025-01-01" | jq
```

Tip: The v2 of the API of 4TU.ResearchData is based on the figshare API , which practically means, that if you dont find something you were looking for in the current documentation https://djehuty.4tu.nl/#x1-640006.1, you can look in : https://docs.figshare.com/#articles_list


### Get 10 software records published after 01-01-2025 (via `curl`)

```bash
curl "https://data.4tu.nl/v2/articles?item_type=9&limit=1&published_since=2025-01-01" | jq
```

### Get information per dataset ID

```bash
curl "https://data.4tu.nl/v2/articles/03c249d6-674c-47cf-918f-1ef9bdafe749" | jq  # /v2/articles/uuid
```

### Get all the files per dataset ID 

```bash
curl "https://data.4tu.nl/v2/articles/03c249d6-674c-47cf-918f-1ef9bdafe749/files" | jq # /v2/articles/uuid/files

## Open this link in the browser to checl the uuid of a file to download (the readme, the last file)
```

### How to download a specific file

```bash
# print the readme file in the screen 

curl "https://data.4tu.nl/file/03c249d6-674c-47cf-918f-1ef9bdafe749/20382d28-0ed9-4f9b-918a-936a2c6f8f76" # /file/article-uuid/file-uuid

#| Command                | Behavior                               |
#| ---------------------- | -------------------------------------- |
#| `curl URL`             | Prints file to screen (no saving)      |
#| `curl -O URL`          | Downloads and saves with original name |
#| `curl -o filename URL` | Downloads and saves with custom name   |
#| `curl -L -O URL`       | Follows redirects and saves file       |
#| `curl -C - -O URL`     | Resumes an interrupted download        |


```

## Collections


### Fetching all collections

```bash
curl "https://data.4tu.nl/v2/collections" | jq 
```

### Fetching collections with parameters

```bash
curl "https://data.4tu.nl/v2/collections?limit=2&published_since=2025-01-01" | jq
```

### Fetching information of a specific collection 

```bash
curl "https://data.4tu.nl/v2/collections/a72aa7ae-7fd2-450b-a1c4-1fa093d15438" | jq
```

### Fetching information of the datasets of a collection

```bash
curl "https://data.4tu.nl/v2/collections/a72aa7ae-7fd2-450b-a1c4-1fa093d15438/articles" | jq
```

## Search Datasets by Keyword

```bash
curl --request POST  --header "Content-Type: application/json" --data '{ "search_for": "aerospace" }' https://data.4tu.nl/v2/articles/search | jq


```

```bash
curl --request POST  --header "Content-Type: application/json" --data '{ "search_for": "architecture" }' https://data.4tu.nl/v2/articles/search | jq
```

## Using a Token to Access Author Info (via `curl`)


#### Create the .env file and copy your private token there

`echo 'API_TOKEN="your_token_here"' > .env`

`echo "Token loaded: ${API_TOKEN:0:5}..."`

`source .env`

### Searching authors by name
```bash 
# Requires setting a token in a sourced .env file (maybe skip this step but mention it
curl --request POST https://data.4tu.nl/v2/account/authors/search --header "Authorization: token ${API_TOKEN}" --header "Content-Type: application/json" --data '{ "search": "Leila" }'  | jq 
```

### Searching accounts within your institution

- "https://data.4tu.nl/v3/groups" (GET) This endpoint lists the groups ID of the institutions that you can use to filter the output of v2/articles/

```bash
curl -X GET "https://data.4tu.nl/v3/groups" | jq
```

## Upload Datasets (POST Requests)


### Basic Upload of metadata to a draft dataset

```bash
curl -X POST https://next.data.4tu.nl/v2/account/articles  --header "Authorization: token ${API_TOKEN_NEXT}" --header "Content-Type: application/json" --data '{ "title": "Dataset RDM session", "authors": [{ "first_name": "Leila", "full_name": "Leila Inigo", "last_name": "Inigo", "orcid_id": "0000-0003-4324-5350" }]  }' | jq
```

### Adding an author to the draft dataset 
- first we need to copy the uuid of the draft dataset created in the previous step in the next.data.4tu.nl website

```bash
curl -X POST "https://next.data.4tu.nl/v2/account/articles/UUID/authors" --header "Authorization: token ${API_TOKEN_NEXT}" --header "Content-Type: application/json" --data '{ "authors": [{ "first_name": "John", "full_name": "Doe", "last_name": "Doe", "orcid_id": "0000-0303-4524-5350" }]  }' | jq
```

### Upload Using YAML Metadata

- They need to download the example_metadata.yaml file 
`curl -o example_metadata.yaml  https://raw.githubusercontent.com/4TUResearchData-Carpentries/WebAPI4RDM/refs/heads/main/Lesson_development/example_metadata.yaml`


#### Upload to next server


```bash
yq '.' example_metadata.yaml | curl -X POST https://next.data.4tu.nl/v2/account/articles -H "Authorization: token ${API_TOKEN_NEXT}" -H "Content-Type: application/json" -d @-
```

#### Upload to the production server

```bash
yq '.' example_metadata.yaml | curl -X POST https://data.4tu.nl/v2/account/articles -H "Authorization: token ${API_TOKEN}" -H "Content-Type: application/json" -d @-
```


#### Command explanation:

`yq '.' example_metadata.yaml` : Converts example_metadata.yaml into JSON

- yq is a command-line tool to read/manipulate YAML (like jq is for JSON).

- `'.'` means "read the full YAML structure as-is".


`-d @-`

- `-d` sends data in the body of the POST request.

- `@-` means: read the request body from stdin (standard input), i.e., the piped-in JSON from yq.



##### Now try to submit it and realize that need a least a file to  submit for review


### File upload 

```bash
curl -X POST "https://next.data.4tu.nl/v3/datasets/dataset-id/upload"   --header "Authorization: token ${API_TOKEN_NEXT}"   --header "Content-Type: multipart/form-data"   -F "file=@absolute-path-to-the-file"
```

#### Now lets take the uuid of the draft just created in the previous example and put it in the endpoint

- For tha data , first download the data using curl from github

`curl -O "https://raw.githubusercontent.com/4TUResearchData-Carpentries/WebAPI4RDM/refs/heads/main/Lesson_development/data_files/test_a.csv"  `


```bash
curl -X POST "https://next.data.4tu.nl/v3/datasets/UUID/upload"   --header "Authorization: token ${API_TOKEN_NEXT}"   --header "Content-Type: multipart/form-data"   -F "file=@ABSOULTE_PATH2FILE"
```

#### FIle upload with strict check for empty files and duplicates

```bash
MD5SUM=$(md5sum "ABSOULTE_PATH2FILE" | awk '{print $1}')
```

```bash
curl -X POST "https://next.data.4tu.nl/v3/datasets/UUID/upload?strict_check=1&md5=${MD5SUM}"   --header "Authorization: token ${API_TOKEN_NEXT}"   --header "Content-Type: multipart/form-data"   -F "file=@ABSOULTE_PATH2FILE"
```

the response of this is that the resource is already available and stops there


### Submit for review 

```bash
yq '.' example_metadata.yaml | curl -X PUT "https://next.data.4tu.nl/v3/datasets/UUID/submit-for-review" --header "Authorization: token ${API_TOKEN_NEXT}" --header "Content-Type: application/json" --data @-
```

## Image preview with IIIF (International Image Interoperability Framework) is a standard for delivering high-resolution images over the web. It allows users to zoom, pan, and interact with images in a web browser.


### Open the browser and insert this endpoint:

https://data.4tu.nl/iiif/v3/c3eee5e4-1651-4541-8fb4-f240fbd1c4ba/full/1024,1024/0/default.jpg 



### Explore the manifest
   - example: https://data.4tu.nl/iiif/v3/c3eee5e4-1651-4541-8fb4-f240fbd1c4ba/full/1024,1024/0/default.jpg
    - dataset of the example : https://data.4tu.nl/datasets/8289a903-7ccf-401b-af66-f5b3c9abe4b6/1

- "https://data.4tu.nl/iiif/v3/<file_uuid>"  (GET, context of the image)

    - example: https://data.4tu.nl/iiif/v3/312f1d4a-2b83-491c-b906-a9d5497f6c9d
    
- "https://data.4tu.nl/iiif/v3/c2a8d5ce-c4ea-46ed-bcdc-e35033e908a8/1/manifest" 

  - To open it in an editor (https://manifest-editor.digirati.services/?tab=recent)

  


## Motivation for Using bash :

Use case: Imagine a researcher is interested in getting the descriptions and categories of datasets uploaded in April 2025

Challenge: The description and categories are exposed if a dataset in specific is queried 

```bash
curl -s "https://data.4tu.nl/v2/articles/fb26fd3f-ba3c-4cf0-8926-14768a256933" | jq
```

### Get the description and categories of the datasets uploaded in April 2025

```bash
curl -s "https://data.4tu.nl/v2/articles/fb26fd3f-ba3c-4cf0-8926-14768a256933" | jq -r '"Description: " + .description + "\nCategories: " + (.categories | map(.title) | join(", "))' > datasets_description_categories.md
```

### Bash Script: Loop Through UUIDs to Collect Metadata

```bash
curl -s "https://data.4tu.nl/v2/articles?published_since=20250401&item_type=3&limit=10" | jq '.[] | {uuid: .uuid}' > article_ids.jsoncat article_ids.json | jq -r '.uuid' | while read uuid; do  curl -s "https://data.4tu.nl/v2/articles/$uuid"  | jq -r '"Description: " + .description + "\nCategories: " + (.categories | map(.title) | join(", "))' >> articles_full_metadata.md ; done
```

### Limitations of Bash Scripts

- Harder to debug or extend
- Tricky to structure or merge data
- Not ideal for large-scale automation


## Using the API with bash

See `get_description_categories_datasets_example.ipynb` for a full example using `requests`.


## Bonus: Using `connect4tu` bash Package

You can also use the [connect4tu](https://github.com/leilaicruz/connect4tu) package for a cleaner bash interface to the 4TU API.
