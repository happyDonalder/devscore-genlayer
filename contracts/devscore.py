# { "Depends": "py-genlayer:test" }

from genlayer import *


class DevScore(gl.Contract):
    """
    GitHub Developer Reputation Scoring Contract
    
    Analyzes GitHub profiles using AI consensus and stores
    reputation scores on-chain.
    """
    
    scores: TreeMap[str, str]

    def __init__(self):
        pass

    @gl.public.write
    def generate_report(self, github_handle: str) -> str:
        """
        Generate reputation report for a GitHub user.
        
        Args:
            github_handle: GitHub username to analyze
            
        Returns:
            JSON string with score, grade, and summary
        """
        github_url = "https://github.com/" + github_handle

        def fetch_and_analyze() -> str:
            data = gl.nondet.web.render(github_url, mode="text")
            prompt = """Analyze this GitHub profile and return JSON:
{
  "score": <0-100>,
  "grade": "<A/B/C/D/E>",
  "summary": "<one sentence summary>"
}

Grading:
A(90-100): Mass influence
B(70-89): Well-known
C(50-69): Active
D(30-49): Beginner
E(0-29): Inactive

Return ONLY valid JSON.

Data:
""" + data[:3000]
            return gl.nondet.exec_prompt(prompt)

        result = gl.eq_principle.strict_eq(fetch_and_analyze)
        self.scores[github_handle] = result
        return result

    @gl.public.view
    def get_score(self, github_handle: str) -> str:
        """
        Retrieve stored score for a GitHub user.
        
        Args:
            github_handle: GitHub username
            
        Returns:
            JSON string with score data, or empty string if not found
        """
        return self.scores.get(github_handle, "")
