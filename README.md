# Docker + Jenkins Automation Project

A CI/CD pipeline where Jenkins pulls code from GitHub, builds a Docker image, and runs the container automatically.

**Tools:** Jenkins, Docker, GitHub

## Architecture

```
Developer -> git push -> GitHub -> Jenkins pipeline
                                      |-- 1. Pull code (checkout)
                                      |-- 2. docker build
                                      |-- 3. docker run (port 8081 -> 80)
                                      '-- 4. Verify container is up
```

## Repository structure

```
.
├── app/
│   └── index.html      # Static web app served by nginx
├── Dockerfile          # nginx:stable-alpine + app files
├── Jenkinsfile         # Declarative pipeline (Windows `bat` steps)
└── README.md
```

## Setup

### 1. Prerequisites
- Docker Desktop (running)
- Jenkins (Windows installer, https://localhost:8080 / http://localhost:8080)
- Git + a GitHub account

### 2. Push this project to GitHub
```bash
git init
git add .
git commit -m "Docker + Jenkins automation project"
git branch -M main
git remote add origin https://github.com/<your-username>/docker-jenkins-project.git
git push -u origin main
```

### 3. Let Jenkins use Docker
- Jenkins service account must be able to run `docker`. On Windows, if the Jenkins service runs as Local System and `docker` fails, change the service to run as your own Windows user (Services -> Jenkins -> Log On), then restart it.
- Verify: Jenkins -> a Freestyle job running `docker version` should succeed.

### 4. Create the pipeline job
1. Jenkins -> **New Item** -> name `docker-jenkins-pipeline` -> **Pipeline**
2. **Pipeline** section -> Definition: *Pipeline script from SCM*
3. SCM: Git, Repository URL: your GitHub repo, Branch: `*/main`
4. Script Path: `Jenkinsfile` -> Save
5. **Build Now**

### 5. (Optional) Auto-trigger on push
- GitHub repo -> Settings -> Webhooks -> payload URL `http://<public-url>/github-webhook/` (needs a public URL, e.g. via ngrok)
- Jenkins job -> Build Triggers -> *GitHub hook trigger for GITScm polling*
- Or simply use *Poll SCM* with schedule `H/2 * * * *`

## Verify
- Console output shows all stages green.
- `docker ps` lists `jenkins-docker-app`.
- Open http://localhost:8081 and see the page.

## Demo of automation
Edit `app/index.html` (e.g. change `v1` to `v2`), commit and push, click **Build Now** (or let the trigger fire), then refresh http://localhost:8081 to see the new version.

## Troubleshooting
| Problem | Fix |
|---|---|
| `docker` not recognized in Jenkins | Run Jenkins service as your user; restart Jenkins; make sure Docker Desktop is running |
| Port 8081 already in use | Change `HOST_PORT` in the Jenkinsfile |
| Checkout fails | Check repo URL/branch; add GitHub credentials if repo is private |
| Linux/Mac Jenkins agent | Replace `bat` with `sh` and `%VAR%` with `$VAR` |

## Screenshots to include in submission
1. Jenkins job configuration
2. Successful build with stage view
3. Console output
4. `docker ps` / Docker Desktop showing the running container
5. Browser showing the app at localhost:8081
6. Updated page after a second build
