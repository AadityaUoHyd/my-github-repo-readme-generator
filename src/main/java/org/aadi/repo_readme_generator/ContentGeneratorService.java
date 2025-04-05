package org.aadi.repo_readme_generator;

import org.aadi.repo_readme_generator.github.GitHubService;
import org.aadi.repo_readme_generator.local.LocalFileService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.nio.file.Files;
import java.nio.file.Paths;

@Service
public class ContentGeneratorService {

    private static final Logger log = LoggerFactory.getLogger(ContentGeneratorService.class);
    private final GitHubService ghService;
    private final LocalFileService localFileService;
    private final LLMService llmService;
    @Value("${app.output.directory}")
    private String outputDirectory;

    public ContentGeneratorService(GitHubService ghService, LocalFileService localFileService, LLMService llmService) {
        this.ghService = ghService;
        this.localFileService = localFileService;
        this.llmService=llmService;
    }

    public String generateContent(String githubUrl, String localPath) throws Exception {
        if (githubUrl != null && !githubUrl.isBlank()) {
            log.info("Processing GitHub URL: {}", githubUrl);
            String[] parts = githubUrl.split("/");
            String owner = parts[parts.length - 2];
            String repo = parts[parts.length - 1];
            ghService.downloadRepositoryContents(owner, repo);
            String conciseCode = new String(Files.readAllBytes(Paths.get(outputDirectory, repo + ".md")));
            String prompt = buildPrompt(conciseCode, repo);
            return llmService.generateReadme(prompt);
        } else if (localPath != null && !localPath.isBlank()) {
            log.info("Processing local path: {}", localPath);
            String outputName = Paths.get(localPath).getFileName().toString();
            localFileService.processLocalDirectory(localPath, outputName);
            String conciseCode = new String(Files.readAllBytes(Paths.get(outputDirectory, outputName + ".md")));
            String prompt = buildPrompt(conciseCode, localPath);
            return llmService.generateReadme(prompt);
        } else {
            throw new IllegalArgumentException("Either GitHub URL or local path must be provided.");
        }
    }

    private String buildPrompt(String conciseCode, String path) {

        return "You are an expert technical writer specializing in writing documentation for software projects. "
                + "You are tasked with writing a new README file for the given project. Your goal is to create an informative documentation for "
                + "software engineers that visit the following repository.\n\n"
                + "First, here's the name of the repository:\n"
                + "<name>\n"
                + path + "\n"
                + "</name>\n\n"
                + "To give you context here is all of the current documentation and source code for the project\n"
                + "<src>\n"
                + conciseCode + "\n"
                + "</src>\n\n"
                + "When writing the README, follow these guidelines:\n\n"
                + "1. Structure:\n"
                + "   - Begin with an attention-grabbing introduction\n"
                + "   - Include the following sections but don’t limit yourself to just these\n"
                + "        - Project Requirements\n"
                + "        - Dependencies\n"
                + "        - Getting Started\n"
                + "            - For the getting started you don’t need to include instructions on how to clone the repo, they are already here\n"
                + "        - How to run the application\n"
                + "        - Relevant Code Examples\n"
                + "   - End with a conclusion that summarizes key points and encourages reader engagement\n\n"
                + "2. Tone and Style:\n"
                + "   - Write in a friendly, natural and educational tone\n"
                + "   - Use clear, concise language\n"
                + "   - Incorporate relevant examples and analogies to explain complex concepts\n"
                + "   - Use lists when appropriate but don’t overuse them\n\n"
                + "3. Text Formatting:\n"
                + "   - The output of this document will be Markdown\n"
                + "   - Use headers (H1 for title, H2 for main sections, H3 for subsections)\n"
                + "   - Keep paragraphs short (3-5 sentences)\n"
                + "   - Proofread for grammar, spelling, and clarity\n"
                + "   - Avoid using any of the following words if possible {WORD_EXCLUDE_LIST}\n\n"
                + "4. Code Formatting:\n"
                + "    - Use clean and concise code examples\n"
                + "    - Avoid including import statements or package declarations for brevity\n"
                + "    - Use consistent indentation (prefer spaces to tabs)\n"
                + "    - Use meaningful variable and function names\n"
                + "    - Break long lines of code for readability\n"
                + "    - If showing output, clearly separate it from the code\n"
                + "    - Include a brief explanation before and/or after each code block\n\n"
                + "5. Output:\n"
                + "   - The output of the README should be in markdown format\n"
                + "   - Use code fences when possible and the correct language definition\n\n"
                + "5. Artifact Usage:\n"
                + "   - Place the entire README content within an artifact\n"
                + "   - Use the artifact type \"text/markdown\" for the documentation\n"
                + "   - Give the artifact a descriptive identifier like \"{{topic}}-README\"\n"
                + "   - Include a title attribute for the artifact\n"
                + "   - Use code fences when possible and the correct language definition\n\n"
                + "Once you’ve completed your outline, write the full blog post and place it within an artifact. "
                + "The artifact should use the type \"text/markdown\", have a descriptive identifier, and include a title attribute.\n\n"
                + "Remember to tailor the content towards an audience of software developers. Output in Markdown with proper line breaks and indentation for readability.";
    }

//    private String extractRepoName(String repoUrl) {
//        // Extract repository name from URL (e.g., "repo" from "https://github.com/user/repo")
//        String[] parts = repoUrl.split("/");
//        return parts.length > 0 ? parts[parts.length - 1] : "Unnamed Repo";
//    }

}
