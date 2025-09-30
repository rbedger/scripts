const fs = require('fs');
const path = require('path');

// --- Main script logic ---

function main() {
    // Check if the correct number of command-line arguments are provided.
    if (process.argv.length !== 4) {
        console.error('Usage: node har-parser.js <path-to-har-file> "<regex-expression>"');
        process.exit(1);
    }

    // Get the file path and regex string from command-line arguments.
    // process.argv[0] is 'node', process.argv[1] is the script path.
    const harFilePath = process.argv[2];
    const regexString = process.argv[3];
    const method = process.argv[4] || 'GET';

    try {
        // Step 1: Read the HAR file.
        const harData = fs.readFileSync(harFilePath, 'utf8');

        // Step 2: Parse the JSON data.
        const harJson = JSON.parse(harData);

        // Step 3: Create a regular expression object.
        // The 'g' flag is not needed as we are testing against individual strings.
        const regex = new RegExp(regexString);

        // Step 4: Initialize a Set to store unique URLs.
        const uniqueUrls = new Set();

        // Step 5: Iterate through the log entries to find request URLs.
        if (harJson && harJson.log && Array.isArray(harJson.log.entries)) {
            for (const entry of harJson.log.entries) {
                if (entry && entry.request && entry.request.url && entry.request.method === method) {
                    const url = entry.request.url;

                    // Step 6: Test the URL against the regex.
                    if (regex.test(url)) {
                        uniqueUrls.add(url);
                    }
                }
            }
        } else {
            console.error('Error: The provided file does not appear to be a valid HAR file.');
            process.exit(1);
        }

        // Step 7: Convert the Set to an array and sort it alphabetically.
        const sortedUrls = Array.from(uniqueUrls).sort();

        // Step 8: Write each unique, sorted URL to standard output.
        sortedUrls.forEach(url => {
            console.log(url);
        });

    } catch (error) {
        // Handle potential errors like file not found or invalid JSON.
        if (error.code === 'ENOENT') {
            console.error(`Error: File not found at path '${harFilePath}'`);
        } else if (error instanceof SyntaxError) {
            console.error('Error: Failed to parse HAR file. It may not be a valid JSON file.');
        } else if (error instanceof RegExp.prototype.constructor) {
            console.error(`Error: Invalid regular expression provided: "${regexString}"`);
        } else {
            console.error(`An unexpected error occurred: ${error.message}`);
        }
        process.exit(1);
    }
}

// Execute the main function.
main();

