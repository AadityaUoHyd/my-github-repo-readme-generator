@import gg.jte.Content

@param String title
@param Content content

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title}</title>

    <link rel="icon" type="image/png" href="/logo.png">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/htmx/1.9.10/htmx.min.js"></script>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(-45deg, #1E3A8A, #9333EA, #EF4444);
            background-size: 400% 400%;
            animation: gradientBG 10s ease infinite;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Inter', sans-serif;
        }

        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .glass-container {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border-radius: 16px;
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);

            width: 100%;
            max-width: 1200px;
            min-width: 600px;

            max-height: 95vh;
            overflow-y: auto;

            border: 1px solid rgba(255, 255, 255, 0.3);
            padding: 2rem;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .fade-in { animation: fadeIn 0.4s ease-out forwards; }

        .logo-title {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 1rem;
        }

        .logo-img {
            height: 48px;
            width: 48px;
            border-radius: 9999px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.4);
        }

        .title-text {
            font-size: 2.5rem;
            font-weight: 800;
            color: white;
            text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.3);
        }

        .footer {
            width: 100%;
            text-align: center;
            padding: 1rem 0;
            background-color: rgba(0, 0, 0, 0.2);
            backdrop-filter: blur(10px);
            margin-top: 2rem;
        }

        .footer p {
            color: #D1D5DB;
            font-size: 0.875rem;
        }
    </style>
</head>
<body>

<div class="glass-container fade-in">

    <div class="text-center mb-8">
        <div class="logo-title">
            <img src="/logo.png" alt="Logo" class="logo-img">
            <h1 class="title-text">GitHub README Generator</h1>
        </div>
    </div>

    ${content}

    <div class="footer">
        <p>&copy; <span id="year"></span> Aaditya Bachchu Chatterjee. All rights reserved.</p>
    </div>

</div>

<script>
    htmx.on('htmx:afterSettle', function(event) {
        if (event.detail.target.id === 'result') {
            event.detail.target.classList.add('fade-in');
        }
    });

    document.getElementById('year').textContent = new Date().getFullYear();
</script>

</body>
</html>
