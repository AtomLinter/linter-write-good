'use babel';

import * as path from 'path';
import {
  // eslint-disable-next-line no-unused-vars
  it, fit, wait, beforeEach, afterEach,
} from 'jasmine-fix';

const { lint } = require('../lib/init').provideLinter();

const validPath = path.join(__dirname, 'fixtures', 'properEnglish.md');
const badPath = path.join(__dirname, 'fixtures', 'English.md');

describe('The write-good provider for Linter', () => {
  beforeEach(async () => {
    atom.workspace.destroyActivePaneItem();
    await atom.packages.activatePackage('linter-write-good');
  });

  it('checks a file with issues', async () => {
    const editor = await atom.workspace.open(badPath);
    const messages = await lint(editor);

    expect(messages.length).toBe(2);

    expect(messages[0].severity).toBe('error');
    expect(messages[0].excerpt).toBe('"Remarkably" is a weasel word and can weaken meaning');
    expect(messages[0].location.file).toBe(badPath);
    expect(messages[0].location.position).toEqual([[0, 0], [0, 10]]);

    expect(messages[1].severity).toBe('error');
    expect(messages[1].excerpt).toBe('"few" is a weasel word');
    expect(messages[1].location.file).toBe(badPath);
    expect(messages[1].location.position).toEqual([[0, 11], [0, 14]]);
  });

  it('finds nothing wrong with a valid file', async () => {
    const editor = await atom.workspace.open(validPath);
    const messages = await lint(editor);

    expect(messages.length).toBe(0);
  });
});
