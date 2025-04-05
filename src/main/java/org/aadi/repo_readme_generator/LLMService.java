package org.aadi.repo_readme_generator;

import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.beans.factory.annotation.Value;

import java.util.Map;
import java.util.List;
import java.util.HashMap;
import java.util.logging.Logger;

@Service
public class LLMService {
    private static final Logger LOGGER = Logger.getLogger(LLMService.class.getName());

    @Value("${mistral.api.key}")
    private String apiKey;

    private static final String MISTRAL_API_URL = "https://api.mistral.ai/v1/chat/completions";

    public String generateReadme(String sourceCode) {
        try {
            RestTemplate restTemplate = new RestTemplate();

            String prompt = "Generate a professional, clean, and informative README.md for the following project source code:\n\n" + sourceCode;

            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("model", "mistral-small-latest");
            requestBody.put("messages", List.of(
                    Map.of("role", "system", "content", "You are an expert README.md generator."),
                    Map.of("role", "user", "content", prompt)
            ));
            requestBody.put("temperature", 0.7);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(apiKey);

            HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(requestBody, headers);

            ResponseEntity<Map> response = restTemplate.exchange(
                    MISTRAL_API_URL,
                    HttpMethod.POST,
                    requestEntity,
                    Map.class
            );

            if (response.getBody() != null && response.getBody().containsKey("choices")) {
                List<Map<String, Object>> choices = (List<Map<String, Object>>) response.getBody().get("choices");
                Map<String, Object> firstChoice = choices.get(0);
                Map<String, Object> message = (Map<String, Object>) firstChoice.get("message");
                return (String) message.get("content");
            }

            return "README generation failed: Invalid response from Mistral AI.";

        } catch (Exception e) {
            LOGGER.severe("Error while generating README: " + e.getMessage());
            return "Error: Unable to generate README. Please check the logs.";
        }
    }
}
