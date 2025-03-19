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
import React from "react";
import Button from "@mui/material/Button";
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';

import { deletePlayer } from "../services/players";

export default function PlayerList({setError, players, setPlayers}) {
    const handleSubmit = async (uuid) => {
        try {
            await deletePlayer(uuid);
            setPlayers(players.filter(player => player.PlayerUuid !== uuid));
        } catch (error) {
            setError(error.response.data.error);
        }
    };

    return <TableContainer component={Paper}>
        <Table aria-label="players table">
            <TableHead>
                <TableRow>
                    <TableCell>Uuid</TableCell>
                    <TableCell>First name</TableCell>
                    <TableCell>Last name</TableCell>
                    <TableCell>Birth date</TableCell>
                    <TableCell></TableCell>
                </TableRow>
            </TableHead>
            <TableBody>
                {players.map(player =>
                    <TableRow key={player.PlayerUuid}>
                        <TableCell>{player.PlayerUuid}</TableCell>
                        <TableCell>{player.FirstName}</TableCell>
                        <TableCell>{player.LastName}</TableCell>
                        <TableCell>{player.BirthDate}</TableCell>
                        <TableCell>
                            <Button variant="contained" color="error" onClick={() => handleSubmit(player.PlayerUuid)}>Delete</Button>
                        </TableCell>
                    </TableRow>
                )}
            </TableBody>
        </Table>

    </TableContainer>
}
