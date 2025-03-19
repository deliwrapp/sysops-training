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
import React, { useState } from "react";
import dayjs from "dayjs";

import Button from "@mui/material/Button";
import { DatePicker } from "@mui/x-date-pickers";
import Grid from "@mui/material/Grid";
import TextField from "@mui/material/TextField";

import { createPlayer } from "../services/players";

export default function CreatePlayer({setError, players, setPlayers}) {
    const [firstName, setFirstName] = useState('');
    const [lastName, setLastName] = useState('');
    const [birthDate, setBirthDate] = useState('');

    const handleSubmit = async function(event) {
        event.preventDefault();
        try {
            const response = await createPlayer({
                firstName, lastName,
                birthDate: dayjs(new Date(birthDate)).format("YYYY-MM-DD")
            });
            setError('');
            setFirstName('');
            setLastName('');
            setBirthDate('');
            setPlayers([...players, response.data]);
        } catch (error) {
            setError(error.response.data.error);
        }
    };

    return <form onSubmit={handleSubmit}>
        <Grid container direction="row" justifyContent="space-between" alignItems="center">
            <Grid item xs={3}>
                <TextField label="First name" onChange={e => setFirstName(e.target.value)} value={firstName} />
            </Grid>
            <Grid item xs={3}>
                <TextField label="Last name" onChange={e => setLastName(e.target.value)} value={lastName} />
            </Grid>
            <Grid item xs={3}>
                <DatePicker label="Birth date" onChange={date => setBirthDate(date)} value={birthDate} />
            </Grid>
            <Grid item xs={1}></Grid>
            <Grid container item xs={2} direction="row" justifyContent="flex-end">
                <Button variant="contained" type="submit">Create Player</Button>
            </Grid>
        </Grid>
    </form>;
}
