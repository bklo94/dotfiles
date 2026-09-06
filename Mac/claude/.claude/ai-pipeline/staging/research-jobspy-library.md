# Research: python-jobspy Library

## Summary

JobSpy (PyPI: `python-jobspy`) is at **v1.1.82** as of the latest `main` branch. The latest published release on GitHub is **v1.1.79** (March 21, 2025). The repository has moved from `cullenwatson/JobSpy` to the `speedyapply` GitHub organization (same repo ID 663203219, 3.1k stars, 625 forks). It scrapes **LinkedIn, Indeed, Glassdoor, Google Jobs, ZipRecruiter, Bayt, and Naukri** concurrently, returning results as a Pandas DataFrame. The library is actively maintained with 10 open issues and recent releases adding Naukri (India), Bayt (Middle East), and Google Jobs support. Notable limitations include LinkedIn rate limiting (~10th page), Indeed filter exclusivity constraints, and a ~1000 result cap per board per search.

## Findings

### 1. Latest Version and Package Info
- **Confidence:** High
- **Detail:** The `pyproject.toml` on `main` shows version `1.1.82`. The latest tagged GitHub release is `v1.1.79` (March 21, 2025). The package uses Poetry for build, requires Python >= 3.10. Key dependencies: `requests`, `beautifulsoup4`, `pandas`, `numpy`, `pydantic` (v2), `tls-client`, `markdownify`, `regex`. The repo has been transferred from `cullenwatson/JobSpy` to `speedyapply/JobSpy` (same repository, not a fork).
- **Sources:** GitHub `pyproject.toml` raw content, GitHub releases page

### 2. Supported Job Boards
- **Confidence:** High
- **Detail:** Seven job boards are currently supported:
  - **LinkedIn** -- Global search, uses `location` parameter only. Most restrictive, rate limits around page 10 with a single IP. Proxies are essentially required for any meaningful volume. Returns `job_level` and `company_industry` fields.
  - **Indeed** -- Best scraper according to docs, no rate limiting. Supports 50+ countries via `country_indeed` param. Returns rich company data: `company_country`, `company_addresses`, `company_employees_label`, `company_revenue_label`, `company_description`, `company_logo`. Also returns `company_industry`.
  - **Glassdoor** -- Shares the `country_indeed` parameter with Indeed. Countries marked with asterisk (*) in the docs support Glassdoor. ~30 countries supported.
  - **Google Jobs** -- Added in v1.1.75 (Oct 2024). Uses a separate `google_search_term` parameter. Requires very specific search syntax -- the recommendation is to search on Google Jobs in your browser, apply filters, then copy whatever appears in the search box.
  - **ZipRecruiter** -- US/Canada only. Uses `location` parameter. Returns salary data with hourly/yearly intervals.
  - **Bayt** -- Added in v1.1.77 (Feb 2025). Middle East job board. Only supports `search_term` parameter currently, searches internationally.
  - **Naukri** -- Added in v1.1.79 (March 2025). India's top job board. Returns additional fields: `skills`, `experience_range`, `company_rating`, `company_reviews_count`, `vacancy_count`, `work_from_home_type`.
- **Sources:** GitHub README, PyPI page, release notes for v1.1.75, v1.1.77, v1.1.79

### 3. Search Parameters and Filters
- **Confidence:** High
- **Detail:** The `scrape_jobs()` function accepts these parameters:

  | Parameter | Type | Description |
  |-----------|------|-------------|
  | `site_name` | list or str | Which boards to scrape. Values: `linkedin`, `zip_recruiter`, `indeed`, `glassdoor`, `google`, `bayt`, `naukri`. Default: all. |
  | `search_term` | str | Keywords to search for |
  | `google_search_term` | str | Separate search term for Google Jobs (the only filtering param for Google) |
  | `location` | str | Geographic location |
  | `distance` | int | Radius in miles, default 50 |
  | `job_type` | str | `fulltime`, `parttime`, `internship`, `contract` |
  | `is_remote` | bool | Filter for remote jobs |
  | `results_wanted` | int | Number of results per site |
  | `easy_apply` | bool | Filter for easy-apply jobs (LinkedIn easy apply no longer works per docs) |
  | `user_agent` | str | Override default user agent |
  | `description_format` | str | `markdown` or `html` (default: markdown) |
  | `offset` | int | Start search from an offset position |
  | `hours_old` | int | Filter by hours since posted (ZipRecruiter/Glassdoor round up to next day) |
  | `verbose` | int | 0=errors only, 1=errors+warnings, 2=all logs (default: 2) |
  | `proxies` | list | Format: `['user:pass@host:port', 'localhost']`. Round-robin per board. |
  | `linkedin_fetch_description` | bool | Fetch full description + direct URL for LinkedIn. Increases requests by O(n). |
  | `linkedin_company_ids` | list[int] | Search by specific LinkedIn company IDs |
  | `country_indeed` | str | Country filter for Indeed and Glassdoor (exact spelling required) |
  | `enforce_annual_salary` | bool | Converts wages to annual salary |
  | `ca_cert` | str | Path to CA cert file for proxies |

  **Filter exclusivity constraints:**
  - Indeed: Only ONE of `{hours_old}`, `{job_type & is_remote}`, `{easy_apply}` can be used per search
  - LinkedIn: Only ONE of `{hours_old}`, `{easy_apply}` can be used per search
- **Sources:** GitHub README, PyPI page

### 4. Output Schema (JobPost)
- **Confidence:** High
- **Detail:** Returns a Pandas DataFrame with these fields:

  **Common fields:** `title`, `company`, `company_url`, `job_url`, `location.country`, `location.city`, `location.state`, `is_remote`, `description`, `job_type`, `job_function`, `job_function.interval`, `job_function.min_amount`, `job_function.max_amount`, `job_function.currency`, `job_function.salary_source` (either `direct_data` or `description` meaning parsed from posting text), `date_posted`, `emails`

  **LinkedIn-specific:** `job_level`

  **LinkedIn + Indeed:** `company_industry`

  **Indeed-specific:** `company_country`, `company_addresses`, `company_employees_label`, `company_revenue_label`, `company_description`, `company_logo`

  **Naukri-specific:** `skills`, `experience_range`, `company_rating`, `company_reviews_count`, `vacancy_count`, `work_from_home_type`

  The `salary_source` field (added in v1.1.60) is particularly useful -- it distinguishes between salary data that came directly from the board's structured data vs. salary info parsed from the job description text.
- **Sources:** GitHub README

### 5. Recent Updates and New Features
- **Confidence:** High
- **Detail:** Key releases in the last ~12 months:

  - **v1.1.79** (March 21, 2025) -- Added **Naukri** support (India's #1 job board)
  - **v1.1.77** (Feb 21, 2025) -- Added **Bayt** support (Middle East). Removed verbose logs by default (now requires `verbose=2`).
  - **v1.1.75** (Oct 24, 2024) -- Added **Google Jobs** support via `site_name='google'` and `google_search_term`
  - **v1.1.66** (Sep 18, 2024) -- Changed Indeed to sort by relevance instead of date for better accuracy. Added automatic quoting of search terms for exact matching on Indeed.
  - **v1.1.65** (Aug 14, 2024) -- Fixed LinkedIn seniority level extraction
  - **v1.1.62** (Aug 4, 2024) -- Added Malaysia support for Indeed/Glassdoor
  - **v1.1.60** (July 18, 2024) -- Added `enforce_annual_salary` param and `salary_source` field
  - **v1.1.59** (July 17, 2024) -- Improved salary extraction from Indeed
- **Sources:** GitHub releases page

### 6. Best Practices
- **Confidence:** High (from official docs + issues)
- **Detail:**
  - **Indeed search syntax** -- Indeed searches descriptions too. Use `-` to exclude terms, `""` for exact match, `(A OR B)` for alternatives. Example: `'"engineering intern" software summer (java OR python OR c++) 2025 -tax -marketing'`
  - **LinkedIn proxies** -- LinkedIn rate limits aggressively (~10th page). Proxies are effectively required for any non-trivial volume. The `proxies` param does round-robin across the list.
  - **Result caps** -- All boards cap at ~1000 results per search. Use `offset` to paginate if needed.
  - **LinkedIn descriptions** -- `linkedin_fetch_description=True` adds full descriptions and direct job URLs but multiplies requests by O(n). Default off for performance.
  - **Google Jobs** -- Requires very specific `google_search_term` syntax. Best approach: search on Google Jobs in browser, apply filters, copy the resulting search string.
  - **429 responses** -- Indicates blocking. Wait between scrapes or rotate proxies.
  - **Verbose logging** -- Now defaults to quiet. Use `verbose=2` for debugging, `verbose=0` for production.
- **Sources:** GitHub README FAQ section, issues #242, #258, #260

### 7. Known Limitations and Open Issues
- **Confidence:** High
- **Detail:**

  **Structural limitations:**
  - ~1000 result cap per board per search (documented)
  - No async support (open feature request #242, marked as priority)
  - LinkedIn easy_apply filter no longer works
  - Indeed/Likedin filter exclusivity constraints (can't combine hours_old + job_type + easy_apply)
  - ZipRecruiter and Glassdoor round `hours_old` up to next day (loses granularity)
  - Bayt only supports `search_term`, no location or other filters

  **Current open issues (as of late March 2025):**
  - #265 -- Pydantic JSON validation/serialization bug for Enums
  - #260 -- `is_remote` data missing from ZipRecruiter jobs
  - #258 -- Inconsistent LinkedIn results
  - #257 -- Optional filters not working
  - #254 -- Feature request: Add zip codes to output
  - #253 -- Feature request: Job benefits and expiration date from Indeed
  - #242 -- Async support (priority, open since Feb 2025)
  - #238 -- Feature request: Easy apply platform detection
  - #235 -- LinkedIn scraper issue with UK searches ('Isle of Man' bug)
  - #226 -- Salary extraction issues

  **Reliability concerns:**
  - The library scrapes live websites, so any frontend changes by LinkedIn/Indeed/Glassdoor can break it
  - LinkedIn is the most fragile -- rate limiting, blocking, inconsistent results are common themes in issues
  - Indeed is the most reliable per the docs ("best scraper currently with no rate limiting")
  - No built-in retry logic or sophisticated rate limiting -- users must handle this themselves
- **Sources:** GitHub issues page, GitHub README notes section

### 8. Relevance to JobCaravan
- **Confidence:** High
- **Detail:** The current JobCaravan scraper (`scraper-worker/`) already attempted to use jobspy but commented it out in `requirements.txt` due to "Git installation issues." The current scraper (`scraper.py`) has a fallback import pattern:
  ```python
  try:
      from jobspy import scrape_jobs
      JOBSPY_AVAILABLE = True
  except ImportError:
      JOBSPY_AVAILABLE = False
  ```
  The project also has standalone `indeed_scraper.py` (35k) and `linkedin_scraper.py` (31k) that implement custom scraping, suggesting jobspy was abandoned in favor of bespoke scrapers. Key comparison points:
  - JobSpy would provide **Google Jobs, ZipRecruiter, Glassdoor, Bayt, Naukri** support in addition to Indeed/LinkedIn -- a significant expansion
  - The custom scrapers may have been written to work around jobspy limitations (LinkedIn reliability, Indeed filter constraints)
  - JobSpy's `enforce_annual_salary` and `salary_source` fields would directly help with the known salary corruption issues documented in the project memory
  - The library's `description_format='markdown'` output and Pandas DataFrame return format would require adapting the existing Flask API layer
- **Sources:** `/home/bklo/Github/JobCaravan/scraper-worker/requirements.txt`, `/home/bklo/Github/JobCaravan/scraper-worker/scraper.py` (lines 24-37)

## Open Questions
- How stable is the `speedyapply/JobSpy` fork/transfer? The PyPI package still lists `cullenwatson` as author -- is the org transfer permanent?
- What is the actual PyPI version? The `pyproject.toml` on `main` shows 1.1.82 but the latest GitHub release is 1.1.79 -- there may be unreleased changes on main.
- How does jobspy handle deduplication across boards? The README does not mention cross-board dedup, which JobCaravan's custom scraper handles.
- What is the proxy architecture recommendation for a Docker-containerized deployment like JobCaravan's? The `proxies` param does round-robin but there is no built-in proxy pool management.
- Does the Naukri support return salary data reliably? It is very new (March 2025) and may be unstable.

## Sources
- GitHub repository: https://github.com/cullenwatson/JobSpy (redirects to https://github.com/speedyapply/JobSpy)
- PyPI package: https://pypi.org/project/python-jobspy/
- GitHub releases: https://github.com/cullenwatson/JobSpy/releases
- GitHub issues: https://github.com/cullenwatson/JobSpy/issues (10 open, 114 closed)
- pyproject.toml (raw): https://raw.githubusercontent.com/speedyapply/JobSpy/main/pyproject.toml
- Local scraper files: `/home/bklo/Github/JobCaravan/scraper-worker/requirements.txt`, `/home/bklo/Github/JobCaravan/scraper-worker/scraper.py`
