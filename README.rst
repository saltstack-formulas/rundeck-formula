===============
rundeck-formula
===============

Install and configure rundeck. Tested in CentOS 6/7 and Ubuntu 14/16.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``init``
--------
Meta state.

``install``
-----------
Install rundeck and rundeck-cli from repo.

``repo``
----------------
Configure the rundeck repo.

``config``
----------
Configure rundeck using either templating-style or ftp-style.

``service``
-----------
Configure the rundeck service to run.
