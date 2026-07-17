import { repos } from "../config/project"
import { GITHUB_TOKEN } from "astro:env/server";


interface GitHubRepo {
    name: string
    description: string | null
    html_url: string
    topics?: string[]
}

interface Project {
    title: string
    desc: string
    tags: string[]
    repo: string
    dotColor: string
}

export async function getProjects() {
    const repoList: Project[] = []
    for (const [i, repo] of repos.entries()) {
        try {
            const response = await fetch(`https://api.github.com/repos/cyb3rflx/${repo}`, { headers: { Authorization: `Bearer ${GITHUB_TOKEN}`, "User-Agent": "cyb3rflx-site" } })
            if (!response.ok) {
                throw new Error(`Response status: ${response.status}`)
            }
            const result = await response.json() as GitHubRepo
            repoList.push({
                title: result.name.replaceAll("-", " "),
                desc: result.description ?? "",
                tags: result.topics ?? [],
                repo: result.html_url,
                dotColor: i % 2 === 0 ? "#22D3EE" : "#F43F5E"
            })
        } catch (error) {
            if (error instanceof Error) {
                console.log(error.message)
            }
        }
    }
    return repoList
}
