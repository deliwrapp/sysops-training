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
import React, { useState, useEffect } from "react";
import Alert from "@mui/material/Alert";
import Container from "@mui/material/Container";
import CssBaseline from '@mui/material/CssBaseline';
import Divider from "@mui/material/Divider";
import Grid from '@mui/material/Grid';
import Typography from "@mui/material/Typography";
import { LocalizationProvider } from '@mui/x-date-pickers';
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs'
import { getPlayers } from "../services/players";

import PlayerList from "./PlayerList";
import CreatePlayer from "./CreatePlayer";

export default function App() {
    const [error, setError] = useState('');
    const [players, setPlayers] = useState([]);

    useEffect(() => {
        const fetchPlayers = async () => {
            try {
                const response = await getPlayers();
                setPlayers(response.data);
                setError('');
            } catch(error) {
                setError('Error fetching players from database');
            }
        };
        fetchPlayers();
    }, []);

    return <LocalizationProvider dateAdapter={AdapterDayjs}>
        <Container maxWidth="md">
            <CssBaseline />
            <Grid container rowSpacing={2}>
                <Grid container direction="row" justifyContent="center" item xs={12}>
                    <Typography variant="h3">Players Registry</Typography>
                </Grid>
                <Grid item xs={12}>
                    <Divider />
                </Grid>
                {error !== '' &&
                    <Grid container style={{ marginBottom: "15px" }}>
                        <Grid item xs={12}>
                            <Alert severity="error" onClose={() => setError('')}>{error}</Alert>
                        </Grid>
                    </Grid>
                }
                <Grid item xs={12}>
                    <CreatePlayer setError={setError} players={players} setPlayers={setPlayers} />
                </Grid>
                <Grid item xs={12}>
                    <Divider />
                </Grid>
                <Grid item xs={12}>
                    <PlayerList setError={setError} players={players} setPlayers={setPlayers} />
                </Grid>
            </Grid>
        </Container>
    </LocalizationProvider>;
}
