Here’s a 3-hour workshop outline, reshaped for TU Delft data stewards. It keeps your core API topics but adds more hands-on time, breaks, and steers all examples toward 4TU.researchData operations that a steward would care about (metadata harvesting, quality checks, automating deposit updates, etc.). Feel free to tweak timings or exercises for your group size.

| Time      | Module                            | Description & Activities                                                                                                                                                                                                                  |
| --------- | --------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 0:00–0:15 | **Welcome & Context**             | – Introductions, goals, logistics<br>– Why 4TU.researchData API matters for TU Delft stewards: automating metadata checks, bulk exports, deposit updates                                                                                  |
| 0:15–0:45 | **1. REST API Fundamentals**      | – HTTP verbs, endpoints, URL structure, status codes<br>– Demo with *curl* / Postman against a public 4TU API endpoint (e.g. `/v2/datasets`)<br>– Quick quiz via show-of-hands                                                            |
| 0:45–1:05 | **2. Steward Use Cases**          | – Harvesting metadata for quality reports<br>– Automated compliance checks (license, embargo dates)<br>– Bulk-downloading supplementary files<br>– Discuss: “Which tasks eat up your time today?” in small groups (5 min)                 |
| 1:05–1:15 | **Break**                         |                                                                                                                                                                                                                                           |
| 1:15–2:00 | **3. Searching & Downloading**    | – Live demo (using the `simple_api__get_call.py` prototype) to fetch the 10 most-recent mechanical-engineering datasets (e.g. wind-tunnel CSVs)<br>– Hands-on: adapt the script to filter by tag, date, or author; show results in Pandas |
| 2:00–2:45 | **4. Publishing & Updating Data** | – Overview of POST/PUT endpoints, authentication via personal token<br>– Demo: update metadata field (e.g. add “discipline: Mechanical Engineering”) on an existing deposit<br>– Hands-on: prepare and push a metadata change             |
| 2:45–2:55 | **Break**                         |                                                                                                                                                                                                                                           |
| 2:55–3:15 | **5. Automation & Pipelines**     | – Scheduling Python scripts (cron, CI) to run periodic harvests or push updates<br>– Show example Jenkins/GitLab-CI YAML fragment that runs your `simple_api__get_call.py` nightly                                                        |
| 3:15–3:30 | **Wrap-up & Next Steps**          | – Q\&A, pointers to 4TU.researchData docs and TU Delft hosting policies<br>– Collect “parking-lot” issues for follow-up or advanced sessions                                                                                              |

---

### Customization tips for TU Delft data stewards

* **Domain examples**: use mechanical-engineering datasets (wind-tunnel logs, FEA results) from 4TU. Show how to query for `discipline:"Mechanical Engineering"` or specific keywords in titles/abstracts.
* **Metadata focus**: emphasize fields your stewards manage (license, embargo, DOI, funder). In the “publishing” module, walk through updating a license via the API, then verifying it on the public HTML page.
* **Authentication & tokens**: integrate with TU Delft’s vault/secrets manager—replace the `load_env_from_script` in `simple_api__get_call.py` with your internal method.
* **Hands-on structure**: break attendees into pairs; each pair tackles one slice (e.g. filtering & export, metadata update, CI setup), then shares back.
* **Pre-work**: send out a quick setup guide (install Python³, requests, pandas, and generate a 4TU API token) so you can dive straight into code at 1:15 PM.
* **Materials**: update the notebook’s code cells to point at `/v2/datasets` instead of `/v2/articles`, add a cell for POSTing metadata changes, and include YAML snippet for GitLab CI.

With this, you’ll hit 180 minutes of focused, practical work—equipping your stewards to both **reuse** and **publish** on 4TU.researchData in an automated, repeatable way. Let me know if you’d like sample code snippets or a filled-out notebook!
