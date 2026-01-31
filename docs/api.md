# API Documentation

## Smart Contract API

### DevScore Contract

Contract Address: `0x02bd9B7D953067500D9E4D5A78DC56e1965e083f`

#### Methods

##### generate_report

Generate a GitHub user reputation report.

```python
@gl.public.write
def generate_report(self, github_handle: str) -> str
```

**Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| github_handle | string | GitHub username |

**Returns:**
```json
{
  "score": 85,
  "grade": "B", 
  "summary": "Active developer with high-quality open source projects"
}
```

**Example:**
```javascript
const result = await contract.generate_report("torvalds");
```

---

##### get_score

Query stored score for a user.

```python
@gl.public.view
def get_score(self, github_handle: str) -> str
```

**Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| github_handle | string | GitHub username |

**Returns:**
- Success: JSON formatted score data
- Not found: Empty string

---

## Frontend API

### GitHub API Calls

#### Get User Info

```javascript
GET https://api.github.com/users/{username}
```

**Response:**
```json
{
  "login": "torvalds",
  "name": "Linus Torvalds",
  "followers": 200000,
  "following": 0,
  "public_repos": 7,
  "avatar_url": "https://avatars.githubusercontent.com/u/1024025"
}
```

#### Get User Repositories

```javascript
GET https://api.github.com/users/{username}/repos?per_page=100&sort=updated
```

**Response:**
```json
[
  {
    "name": "linux",
    "stargazers_count": 150000,
    "forks_count": 50000,
    "language": "C"
  }
]
```

---

## Error Codes

| Code | Message | Description |
|------|---------|-------------|
| 4001 | User rejected | User cancelled transaction |
| -32603 | Internal error | RPC internal error |
| duplicate key | Already exists | User already analyzed |

---

## Rate Limits

### GitHub API
- Unauthenticated: 60 requests/hour
- Authenticated: 5000 requests/hour

### GenLayer RPC
- Unlimited (testnet)
