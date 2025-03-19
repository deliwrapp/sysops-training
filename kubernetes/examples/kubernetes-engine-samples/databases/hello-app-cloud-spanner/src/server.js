/*
Copyright 2023 Google LLC
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    https://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
(async () => {
  const crypto = require('crypto');
  const express = require("express");
  const path = require('path');
  const cors = require('cors');
  const port = process.env.PORT || 8080;
  const app = express();

  app.use(cors(), express.json(), express.static(path.resolve(__dirname, '../client/build')));

  // Configures the Cloud Spanner client
  const { Spanner } = require('@google-cloud/spanner');
  const spanner = new Spanner({ projectId: process.env.GOOGLE_CLOUD_PROJECT_ID });
  const instance = spanner.instance(process.env.CLOUD_SPANNER_INSTANCE || 'hello-instance');
  const database = instance.database(process.env.CLOUD_SPANNER_DATABASE || 'hello-database');

  // Retrieves the database dialect
  await database.getMetadata();
  const isPostgreSQLDialect = database.metadata.databaseDialect === "POSTGRESQL";

  //Get all players
  app.get("/api/v1/players", async (req, res) => {
    const [rows] = await database.run("SELECT * FROM Players");
    res.send(rows);
  });

  // Insert a player (warning: no validation is done)
  app.post("/api/v1/players", async (req, res) => {
    const { firstName, lastName, birthDate } = req.body;

    const uuid = crypto.randomUUID();
    database.runTransaction(async (error, transaction) => {
      if (error) {
        res.status(500).send({ error: error.details });
        return;
      }

      try {
        if (isPostgreSQLDialect) {
          await transaction.runUpdate({
            sql: `INSERT INTO Players
            (PlayerUuid, FirstName, LastName, BirthDate)
            VALUES ($1, $2, $3, $4)`,
            params: {
              p1: uuid,
              p2: firstName,
              p3: lastName,
              p4: new Date(birthDate)
            }
          });
        } else {
          await transaction.runUpdate({
            sql: `INSERT INTO Players
            (PlayerUuid, FirstName, LastName, BirthDate)
            VALUES (@playerUuid, @firstName, @lastName, @birthDate)`,
            params: {
              playerUuid: uuid,
              firstName,
              lastName,
              birthDate
            }
          });
        }
        await transaction.commit();

        res.status(201).send({
          PlayerUuid: uuid,
          FirstName: firstName,
          LastName: lastName,
          BirthDate: birthDate
        });
      } catch (error) {
        res.status(500).send({ error: error.details });
      }
    });
  });

  // Deletes a given player (warning: no validation is done)
  app.delete("/api/v1/players/:uuid", async (req, res) => {
    const uuid = req.params.uuid;

    database.runTransaction(async (error, transaction) => {
      if (error) {
        res.status(500).send({ error: error.details });
        return;
      }

      try {
        if (isPostgreSQLDialect) {
          await transaction.runUpdate({
            sql: `DELETE FROM Players WHERE PlayerUuid = $1`,
            params: { p1: uuid }
          });
        } else {
          await transaction.runUpdate({
            sql: `DELETE FROM Players WHERE PlayerUuid = @playerUuid`,
            params: { playerUuid: uuid }
          });
        }
        await transaction.commit();

        res.status(204).send();
      } catch (error) {
        res.status(500).send({ error: error.details });
      }
    });
  });

  app.get("*", (_req, res) => {
    res.sendFile(path.resolve(__dirname, "../client/build", "index.html"));
  });

  //Start the server
  app.listen(port, () => console.log(`App listening on port ${port}!`))
})();
