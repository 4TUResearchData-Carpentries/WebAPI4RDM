Here’s a 3-hour workshop proposal tailored for data stewards from all four Dutch technical universities. It mixes plenary demos with institution-focused break-outs so each steward practices on examples most relevant to their domain.

| Time      | Module                            | Description & Activities                                                                                                                                   |
| --------- | --------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 0:00–0:15 | **Welcome & Objectives**          | – Quick round-robin: name, institution, top “metadata headache” today<br>– Goals: understand 4TU.researchData API, learn to harvest, publish, automate     |
| 0:15–0:45 | **1. REST API Fundamentals**      | – HTTP verbs, endpoints, URL patterns, status codes<br>– Live demo: GET `/v2/datasets` with curl/Postman<br>– Show how JSON is structured for repositories |
| 0:45–1:10 | **2. Cross-University Use Cases** | – Plenary: brainstorm the top 2 tasks at each campus<br>  - **TU Delft**: mechanical-engineering shares (wind-tunnel CSVs, FEA data)                       |

* **Wageningen**: agricultural/environmental time-series
* **TU Eindhoven**: sensor/IoT telemetry
* **Twente**: HCI experiment logs/regulatory compliance
  – Map those to five core API actions: search, filter, download, update metadata, bulk export                       |
  \| 1:10–1:20       | **Break**                                   |                                                                                                                                                                                                                                                |
  \| 1:20–2:05       | **3. Hands-On: Searching & Downloading**     | 1. Attendees split by university

2. Each team runs/edits the `simple_api__get_call.py` prototype to:

   * Filter by their discipline tag (e.g. `discipline:"Mechanical Engineering"` for Delft)
   * Restrict by date range or funder code
   * Download first 5 matching datasets into a Pandas DataFrame
3. Teams share one interesting dataset and how they filtered it                                                                                                                    |
   \| 2:05–2:40       | **4. Hands-On: Publishing, Updating & Automating** | 1. Demo: POST a metadata patch (e.g. set `license: CC-BY` or add `funder: NWO`) via `/v2/datasets/{id}/metadata` (auth via token)<br>2. Teams prepare a small JSON patch and push an update to one of their own “test” deposits<br>3. Walk through scheduling that script as a nightly job (cron/GitLab-CI YAML snippet) so compliance checks run automatically |
   \| 2:40–3:00       | **5. Wrap-Up & Next Steps**                 | – Q\&A, share links to 4TU.researchData API docs and TU library policies per campus<br>– “Parking-lot” for deeper topics (e.g. OAuth2 flows, DOI minting)<br>– Optional follow-up: advanced pipeline clinic |

---

### Example filters & endpoints per university

* **TU Delft** (Mechanical Eng):

  ```http
  GET /v2/datasets?filter=discipline:"Mechanical Engineering"&sort=created:desc&limit=5
  ```
* **Wageningen** (Agri/Env):

  ```http
  GET /v2/datasets?filter=keyword:"soil moisture"&spatialExtent:"Netherlands"&limit=5
  ```
* **TU Eindhoven** (Electronics/IoT):

  ```http
  GET /v2/datasets?filter=metadata.sensorType:"Temperature"&dateFrom:2025-01-01&limit=5
  ```
* **Twente** (HCI/Regulation):

  ```http
  GET /v2/datasets?filter=keyword:"user study"&license:"CC-BY"&limit=5
  ```

### Tips for a smooth session

1. **Pre-work**: Distribute instructions to install Python 3, `requests`, `pandas`, generate a 4TU token.
2. **Break-out support**: Pair each campus group with a helper who knows their local policies (e.g. Wageningen’s CITES restrictions, Twente’s GDPR checklist).
3. **Notebook updates**:

   * Add cells for each endpoint above.
   * Include a POST cell template for metadata patches.
   * Embed a GitLab-CI YAML snippet that runs `python simple_api__get_call.py` every night at 02:00.
4. **Materials**: Provide a one-pager with all endpoint URLs, common query parameters, and a troubleshooting FAQ (token expired, 403 vs. 404 errors).

This structure ensures every steward leaves with hands-on experience searching, downloading, updating, and automating workflows against 4TU.researchData—tailored to their institution’s pain points. Let me know if you’d like sample notebook cells or CI snippets!
