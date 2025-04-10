package org.aadi.repo_readme_generator;

import org.aadi.repo_readme_generator.github.GitHubService;
import org.aadi.repo_readme_generator.local.LocalFileService;
import gg.jte.TemplateEngine;
import gg.jte.output.StringOutput;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.Year;
import java.util.Map;

@Controller
public class ContentGeneratorController {
    private static final Logger log = LoggerFactory.getLogger(ContentGeneratorController.class);
    private final GitHubService ghService;
    private final LocalFileService localFileService;
    private final TemplateEngine templateEngine;
    private final ContentGeneratorService contentGeneratorService;

    public ContentGeneratorController(GitHubService ghService, LocalFileService localFileService, TemplateEngine templateEngine, ContentGeneratorService contentGeneratorService) {
        this.ghService = ghService;
        this.localFileService = localFileService;
        this.templateEngine = templateEngine;
        this.contentGeneratorService = contentGeneratorService;
    }

    @GetMapping("/")
    public String index() {
        return "index";
    }

    @PostMapping("/generate")
    @ResponseBody
    public ResponseEntity<String> generate(@RequestParam(required = false) String githubUrl,
                                                 @RequestParam(required = false) String localPath) {

        if ((githubUrl == null || githubUrl.isBlank()) && (localPath == null || localPath.isBlank())) {
            return ResponseEntity.badRequest().body("Error: Either GitHub URL or local path must be provided.");
        }

        try {
            String content = contentGeneratorService.generateContent(githubUrl, localPath);
            content = content.replace("\\n", "\n");
            // Convert Year to String to avoid JTE compilation error
            String currentYear = String.valueOf(Year.now().getValue());

            StringOutput output = new StringOutput();
            templateEngine.render("result.jte", Map.of(
                    "content", content,
                    "currentYear", currentYear
            ), output);
            return ResponseEntity.ok(output.toString());
        } catch (Exception e) {
            log.error("Error generating content", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error generating content: " + e.getMessage());
        }
    }

}
